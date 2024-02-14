import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todonote/layout/homeLayout.dart';
import 'package:todonote/shared/blocObserver.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(MaterialApp(home: MyApp()));
    },
    blocObserver: MyBlocObserver(),
  );
}
