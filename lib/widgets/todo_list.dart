import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoList extends StatefulWidget {
  final List<Todo> todos;
  final Function(Todo) onDelete;
  final Function(Todo) onSelect;
  final Function(Todo, String) onEditTitle;

  TodoList({
    required this.todos,
    required this.onDelete,
    required this.onSelect,
    required this.onEditTitle,
  });

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Wrap with SingleChildScrollView
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true, // Add shrinkWrap: true
            itemCount: widget.todos.length,
            itemBuilder: (context, index) {
              final todo = widget.todos[index];
              return ListTile(
                title: todo.isEditing
                    ? TextFormField(
                  initialValue: todo.title,
                  onChanged: (value) {
                    // Pass both todo and value to onEditTitle function
                    widget.onEditTitle(todo, value);
                  },
                  onEditingComplete: () {
                    // Save edited title
                    widget.onEditTitle(todo, todo.title);
                    setState(() {
                      todo.isEditing = false;
                    });
                  },
                )
                    : Text(todo.title),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      todo.isCompleted = value!;
                    });
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          todo.isEditing = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        widget.onDelete(todo);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  widget.onSelect(todo);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
