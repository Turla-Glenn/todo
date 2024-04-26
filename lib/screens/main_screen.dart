import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../widgets/todo_list.dart';
import '../widgets/quote_widget.dart';
import '../services/quote_service.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/gif_widget.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/storage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Todo> _todos = [];
  late QuoteService _quoteService;
  late String _theme = 'Light';
  bool _showQuoteAndGif = true;

  @override
  void initState() {
    super.initState();
    _quoteService = QuoteService();
    _loadTheme();
    _loadTodos();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _theme = prefs.getString('theme') ?? 'Light';
    });
  }

  void _loadTodos() async {
    List<Todo> todos = await Storage.loadTodos();
    setState(() {
      _todos.addAll(todos);
      // Check if there are any todos, if yes, hide the quote and GIF
      _showQuoteAndGif = _todos.isEmpty;
    });
  }

  void _addTodo(String todoTitle) {
    setState(() {
      _todos.add(Todo(title: todoTitle));
      // Check if there are any todos, if yes, hide the quote and GIF
      _showQuoteAndGif = _todos.isEmpty;
    });
    Storage.saveTodos(_todos); // Save todos to storage
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.remove(todo);
      // Check if there are any todos, if not, show the quote and GIF
      _showQuoteAndGif = _todos.isEmpty;
    });
    Storage.saveTodos(_todos); // Save todos to storage
  }

  void _editTodoTitle(Todo todo, String newTitle) {
    setState(() {
      todo.title = newTitle;
    });
    Storage.saveTodos(_todos); // Save todos to storage
  }

  void _onChangeTheme(String newTheme) {
    setState(() {
      _theme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme == 'Light'
          ? ThemeData.light()
          : ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('To Do List'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                final newTheme = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      theme: _theme,
                      onChangeTheme: _onChangeTheme,
                    ),
                  ),
                );
                if (newTheme != null) {
                  _onChangeTheme(newTheme);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // Only show quote and GIF if _showQuoteAndGif is true
                if (_showQuoteAndGif)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QuoteWidget(quoteService: _quoteService),
                      SizedBox(height: 90),
                      GifWidget(),
                    ],
                  ),
                // Show the todo list if there are todos
                if (_todos.isNotEmpty)
                  TodoList(
                    todos: _todos,
                    onDelete: _deleteTodo,
                    onSelect: (selected) {
                      // Implement selecting logic here
                    },
                    onEditTitle: _editTodoTitle,
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddTodoDialog(
                onAdd: _addTodo,
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
