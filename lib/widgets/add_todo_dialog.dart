import 'package:flutter/material.dart';

class AddTodoDialog extends StatelessWidget {
  final Function(String) onAdd;

  const AddTodoDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String todoTitle = '';

    return AlertDialog(
      title: Text('Add Todo'),
      content: TextField(
        onChanged: (value) {
          todoTitle = value;
        },
        decoration: InputDecoration(
          hintText: 'Enter todo title',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (todoTitle.isNotEmpty) {
              onAdd(todoTitle);
              Navigator.pop(context);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
