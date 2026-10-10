import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
int _selectedIndex = 0 ;

// handling the tapping on bottom navigation items
void _onTapItem(int index){
  print(index);
  setState(() {
    _selectedIndex = index;
  });  
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.transform),
        label: "Conversation",
        ),
         BottomNavigationBarItem(icon: Icon(Icons.history),
        label: "History",
    )
    ],
    onTap: _onTapItem,
    ),
    );
  }
}
