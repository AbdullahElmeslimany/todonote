import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todonote/shared/cubit/cubit.dart';
import 'package:todonote/shared/cubit/states.dart';

class MyApp extends StatelessWidget {
  var scafoldkey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var statusController = TextEditingController();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CubitApp()..createDatabase(),
      child: BlocConsumer<CubitApp, AppState>(
          listener: (BuildContext context, AppState state) {
        if (state is InsertIntoDatabaseState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppState state) {
        CubitApp cubit = CubitApp.get(context);
        return Scaffold(
            key: scafoldkey,
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text(CubitApp.get(context)
                  .titles[CubitApp.get(context).currentIndex]),
            ),
            body: conditionalBuilder(
              condition: true,
              builder: (context) => CubitApp.get(context)
                  .screens[CubitApp.get(context).currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: CubitApp.get(context).currentIndex,
              onTap: (index) {
                CubitApp.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_task,
                      color: Colors.red,
                    ),
                    label: 'New'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_box_outlined, color: Colors.red),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined, color: Colors.red),
                    label: 'Archived'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(
                  cubit.floaticon,
                  //  color: Colors.yellow.withOpacity(0.5),
                ),
                onPressed: () {
                  if (cubit.isbottomnavigate) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertIntoDatabase(titleController.text,
                          dateController.text, timeController.text);
                      cubit.changeBottomSheet(Icons.add_task, true);
                      titleController.clear();
                      dateController.clear();
                      timeController.clear();
                      Navigator.pop(context);
                      /* .then((value) {
                           GetFromDatabase(database).then((value) {
                              tasks=value;
                              print(tasks);
                              Navigator.pop(context);
                              isbottomnavigate=false;
                              /*setState(() {
                              floaticon=Icons.add;
                       });*/
                            });

                          });*/
                    }
                  } else {
                    scafoldkey.currentState!.showBottomSheet((context) => Form(
                          key: formKey,
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: 40, right: 40, top: 40, bottom: 40),
                              color: Colors.yellow.withOpacity(0.3),
                              width: double.infinity,
                              //   height: 370,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 70,
                                    // color: Colors.black,
                                    child: TextFormField(
                                      controller: titleController,
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return " empty input, title must be entered";
                                        else
                                          return null;
                                      },
                                      decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          icon: Icon(
                                            Icons.title,
                                            color: Colors.red,
                                          ),
                                          hintText: 'task title '),
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    // color: Colors.black,
                                    child: TextFormField(
                                      controller: dateController,
                                      validator: (value) {
                                        if (value!.isEmpty)
                                          return " empty input, date must be entered";
                                        else
                                          return null;
                                      },
                                      decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 3),
                                        ),
                                        icon: Icon(
                                          Icons.date_range,
                                          color: Colors.red,
                                        ),
                                        hintText: 'task date',
                                      ),
                                      onTap: () {
                                        _selectDate(context).then((value) {
                                          print(value.toString());
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    // color: Colors.black,
                                    child: TextFormField(
                                        controller: timeController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return " empty input, time must be entered";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.datetime,
                                        decoration: const InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 3),
                                          ),
                                          icon: Icon(
                                            Icons.timer,
                                            color: Colors.red,
                                          ),
                                          hintText: 'task time',
                                        ),
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                            print(value.format(context));
                                          });
                                        }),
                                  ),
                                ],
                              )),
                        ));
                    cubit.isbottomnavigate = true;
                    /*setState(() {
                floaticon=Icons.add_task;
              });*/
                  }
                }));
      }),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2023, 1, 1),
    );
    return picked!;
  }
}
