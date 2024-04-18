import 'package:flutter/material.dart';
import 'package:nanopos/database/todo_db.dart';
import 'package:nanopos/models/todo.dart';
import 'package:nanopos/views/Todo/todo_widget.dart';
import 'package:intl/intl.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  Future<List<Todo>>? futureTodos;
  final todoDB = TodoDB();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodos();
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDB.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: FutureBuilder<List<Todo>>(
          future: futureTodos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final todos = snapshot.data!;
              return todos.isEmpty
                  ? const Center(
                      child: Text(
                        'No Todos',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 12,
                          ),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        final subtitle = DateFormat('yyyy/MM/dd').format(
                            DateTime.parse(todo.updated_at ?? todo.created_at));
                            return ListTile(
                              title: Text(todo.title,style: const TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Text(subtitle),
                              trailing: IconButton(onPressed: ()async{
                                await todoDB.delete(todo.id);
                                fetchTodos();
                              }, icon: const Icon(Icons.delete,color: Colors.red,)),
                              onTap: (){
                                showDialog(context: context, builder: (context)=>CreateTodoWidget(todo: todo,onSubmit: (title)async{
                                  await todoDB.update(id: todo.id,title: title);
                                  fetchTodos();
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                  },));
                              },
                            );
                      });
            }
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => CreateTodoWidget(
                      onSubmit: (title) async {
                        await todoDB.create(title: title);
                        if (!mounted) return;
                        fetchTodos();
                        Navigator.of(context).pop();
                      },
                    ));
          }),
    );
  }
}
