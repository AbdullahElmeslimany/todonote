import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todonote/modules/archivedTasks.dart';
import 'package:todonote/modules/doneTasks.dart';
import 'package:todonote/modules/newTasks.dart';
import 'package:todonote/shared/cubit/states.dart';

class CubitApp extends Cubit<AppState> {
  // CubitApp(AppState initialState) : super(initialState);
  CubitApp() : super(intialState());
  //create object
  static CubitApp get(context) => BlocProvider.of(context);

  List<Map> tasks = [];
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  List<Widget> screens = [
    const newTasks(),
    const doneTasks(),
    const archivedTasks()
  ];
  List<String> titles = ['New Tasks', 'Done TASKS', 'Archived Tasks'];
  var currentIndex = 0;
  var database;
  bool isbottomnavigate = false;
  IconData floaticon = Icons.add;

  void changeIndex(int index) {
    currentIndex = index;
    emit(changeNavBar());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'create table tasks (id integer primary key, title text, date text, time text,status text)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error');
      });
    }, onOpen: (database) {
      getFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      print('database created');
      emit(CreateDatabaseState());
    });
  }

  insertIntoDatabase(
    String title,
    String date,
    String time,
  ) {
    return database.transaction((txn) async {
      txn
          .rawInsert(
              'insert into  tasks (title,date,time,status) values("$title","$date","$time","new")')
          .then((value) {
        // tasks=value;
        changeBottomSheet(Icons.add, 
        
        false);
        print('data added');
        emit(InsertIntoDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('error during inserting ${error.toString()}');
      });
      return null;
    });
  }

  void getFromDatabase(database) {
    emit(GetFromDatabaseStateLoading());
    database.rawQuery("select * from tasks").then((value) {
      tasks = value;
      for (var element in tasks) {
        if (element['status'] == 'done') {
          donetasks.add(element);
        } else if (element['status'] == 'archived') {
          archivedtasks.add(element);
        } else {
          newtasks.add(element);
        }
      }
      emit(GetFromDatabaseState());
      // emit(UpdateDatabaseState());
    });
  }

  void updateDatabase(String s,
      {required String status, required String id}) async {
    newtasks = [];
    donetasks = [];
    archivedtasks = [];
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getFromDatabase(database);
      emit(UpdateDatabaseState());
    });

    // print('updated: $count');
  }

  void deleteDatabase(String s, {required String id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      tasks.removeAt(int.parse(id));
      getFromDatabase(database);

      emit(DeleteDatabaseState());
      print(value);
    });

    // print('updated: $count');
  }

  void changeBottomSheet(IconData icon, bool show) {
    isbottomnavigate = show;
    floaticon = icon;
    emit(ChangeBottomSheetState());
  }
}
