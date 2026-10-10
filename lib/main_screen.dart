import 'package:ai_saas_app/constants/colors.dart';
import 'package:ai_saas_app/screens/home_page.dart';
import 'package:ai_saas_app/screens/user_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // handling the tapping on bottom navigation items
  void _onTapItem(int index) {
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: "Conversation",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
        onTap: _onTapItem,
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 3, 42, 34),
        selectedItemColor: const Color.fromARGB(255, 252, 254, 255),
        backgroundColor: mainColor,
      ),
      body: _selectedIndex == 0 ? const HomePage() : UserHistory(),
    );
  }
}
