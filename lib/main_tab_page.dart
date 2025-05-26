import 'package:chungju_tltl/chat_page.dart';
import 'package:chungju_tltl/todo_remote_page.dart';
import 'package:flutter/material.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _selectedIndex = 0;
  final List<Widget> _page = const [
    TodoRemotePage(),
    ChatPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: '할 일'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: '채팅'
          )
        ],
      ),
    );
  }
}