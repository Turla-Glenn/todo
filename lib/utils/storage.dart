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
