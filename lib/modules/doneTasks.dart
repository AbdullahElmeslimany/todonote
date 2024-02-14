import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todonote/shared/components.dart';
import 'package:todonote/shared/cubit/cubit.dart';
import 'package:todonote/shared/cubit/states.dart';

class doneTasks extends StatelessWidget {
  const doneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = CubitApp.get(context).donetasks;
        return TaskBuildeCondition(tasks: tasks);
      },
    );
  }
}
