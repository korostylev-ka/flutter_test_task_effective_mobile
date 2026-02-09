import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task_for_effective_mobile/presentation/main_screen.dart';
import 'package:test_task_for_effective_mobile/state/characters_state.dart';
import 'data/db/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    DBService.instance();
  }
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
    return MainScreen();
  }
}
