import 'package:flutter/material.dart';
import 'package:todonote/shared/cubit/cubit.dart';

Widget buildTaskItem(Map items, context) => Dismissible(
      key: UniqueKey(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.red,
              child: Center(child: Text('${items['date']}')),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${items['title']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    '${items['time']}',
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  CubitApp.get(context).UpdateDatabase('done', '${items['id']}',
                      status: '', id: '');
                },
                icon: const Icon(
                  Icons.check_box_rounded,
                  color: Colors.red,
                )),
            IconButton(
                onPressed: () {
                  CubitApp.get(context).UpdateDatabase(
                      'archived', '${items['id']}',
                      status: '', id: '');
                },
                icon: const Icon(
                  Icons.archive_outlined,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
      onDismissed: (direction) {
        CubitApp.get(context).deleteDatabase('${items['id']}', id: '');
      },
    );
Widget TaskBuildeCondition({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.yellow.withOpacity(0.5),
                margin: const EdgeInsets.only(left: 20, right: 20),
              ),
          itemCount: tasks.length),
      fallback: (context) => const Center(child: Text('No tasks yet!')),
    );
