import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  final String? apiKey;

  QuoteService({this.apiKey});

  Future<String> fetchDailyQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.quotable.io/random'),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return decodedResponse['content'];
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      throw Exception('Error fetching quote: $e');
    }
  }
}




utils folder

storage.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class Storage {
  static Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? todoStrings = prefs.getStringList('todos');

    if (todoStrings == null) {
      return [];
    }

    return todoStrings.map((e) => Todo.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todoStrings = todos.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList('todos', todoStrings);
  }
}





widgets folder

add_todo_dialog.dart
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



gif_widget.dart
// widgets/gif_widget.dart
import 'package:flutter/material.dart';

class GifWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('lib/assets/tired.gif');// Replace with actual path
  }
}

quote_widget.dart
import 'package:flutter/material.dart';
import '../services/quote_service.dart';

class QuoteWidget extends StatefulWidget {
  final QuoteService quoteService;

  QuoteWidget({required this.quoteService});

  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  late Future<String> _quoteFuture;

  @override
  void initState() {
    super.initState();
    _quoteFuture = widget.quoteService.fetchDailyQuote();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _quoteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Failed to load quote');
        } else {
          return Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                snapshot.data.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
    );
  }
}



todo_list.dart

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
