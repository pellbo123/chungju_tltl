import 'package:chungju_tltl/home_page.dart';
import 'package:chungju_tltl/todo_local_page.dart';
import 'package:chungju_tltl/todo_remote_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://snupzbbjtrrmhvacjwgu.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNudXB6YmJqdHJybWh2YWNqd2d1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc2MTc1MDYsImV4cCI6MjA2MzE5MzUwNn0.WOi4aDxfvaXGUHG51-dw_4UWKmGj0cWPPrCNVDHna5E"

  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO 프로젝트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/todo-local': (context) => const TodoLocalPage(),
        '/todo-remote': (context) => const TodoRemotePage()
      }

    );
  }
}
