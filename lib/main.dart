import 'package:flutter/material.dart';
import 'package:todo_front/app/pages/tasks_page.dart';
 // Importe corretamente a sua HomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),  // Certifique-se de que é a HomePage que está sendo carregada
    );
  }
}
