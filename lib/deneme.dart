import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dark/Light Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Mode:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Text(
                  themeProvider.isDarkMode ? '' : '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                );
              },
            ),
            SizedBox(height: 20),
            Switch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                if (value) {
                  // Dark Mode'u etkinleştir
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                } else {
                  // Light Mode'u etkinleştir
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
