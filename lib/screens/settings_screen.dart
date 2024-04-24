import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final String theme;
  final Function(String) onChangeTheme;

  SettingsScreen({required this.theme, required this.onChangeTheme});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Theme:'),
            Container(
              height: 50,
              child: DropdownButton<String>(
                value: _selectedTheme,
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    await prefs.setString('theme', newValue);
                    setState(() {
                      _selectedTheme = newValue;
                    });
                    widget.onChangeTheme(newValue); // Notify parent widget
                  }
                },
                items: <String>[
                  'Light',
                  'Dark',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
