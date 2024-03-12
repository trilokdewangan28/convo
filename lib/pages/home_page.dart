import 'package:convo/pages/chats_page.dart';
import 'package:convo/pages/users_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final List<Widget> _pages = [
    ChatsPage(),
    UsersPage()
  ];

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      body: _pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (_index) {
          setState(() {
            currentPage = _index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(Icons.chat_bubble_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Users',
            icon: Icon(Icons.supervised_user_circle_sharp),
          ),
        ],
      ),
    );
  }
}
