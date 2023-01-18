import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:task_list/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff244f26),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('dd/MMM/yy - HH:mm').format(todo.dateTime),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
        endActionPane: ActionPane(motion: DrawerMotion(), children: [
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) {
              onDelete(todo);
            },
          ),
        ]),
      ),
    );
  }
}
