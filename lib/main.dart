import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task_for_effective_mobile/presentation/main_screen.dart';
import 'package:test_task_for_effective_mobile/resources/Strings.dart';
import 'package:test_task_for_effective_mobile/state/characters_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CharactersState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.projectTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainScreen(),
    );
  }
}
