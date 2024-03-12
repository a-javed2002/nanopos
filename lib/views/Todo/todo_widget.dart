import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nanopos/models/todo.dart';

class CreateTodoWidget extends StatefulWidget {
  final Todo? todo;
  final ValueChanged<String> onSubmit;
  const CreateTodoWidget({super.key, this.todo, required this.onSubmit});

  @override
  State<CreateTodoWidget> createState() => _CreateTodoWidgetState();
}

class _CreateTodoWidgetState extends State<CreateTodoWidget> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _controller.text = widget.todo!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    return AlertDialog(
      title: Text(isEditing ? 'Edit Todo' : 'Add todo'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Title'),
          validator: (value) =>
              value != null && value.isEmpty ? 'Title is required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if(_formKey.currentState!.validate()){
              widget.onSubmit(_controller.text);
            }
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
