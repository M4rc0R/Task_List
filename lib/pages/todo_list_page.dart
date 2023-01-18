import 'package:flutter/material.dart';
import 'package:task_list/repositorys/todo_repository.dart';
import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deleteTodo;
  int? deleteTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff2f4b26),
          title: const Text(
            'Lista de Tarefas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: Color(0xffc0d7bb),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          labelStyle: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                          ),
                          hintText: 'Ex. Estudar Flutter',
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.black),
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff3e885b),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = ' O campo não pode ser vazio';
                          });
                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff149911),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Voce possui ${todos.length} tarefas pendentes',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirm,
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff256d1b),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Text('Limpar tudo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deleteTodo = todo;
    deleteTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white70,
          onPressed: () {
            setState(() {
              todos.insert(deleteTodoPos!, deleteTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirm() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tarefas'),
              content: Text('Deseja realmente limpar todas as tarefas?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(primary: Colors.black),
                    child: Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      delatarTodosTodos();
                    },
                    style: TextButton.styleFrom(primary: Colors.red),
                    child: Text('Limpar tudo')),
              ],
            ));
  }

  void delatarTodosTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
