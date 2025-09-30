import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_rdv_page.dart';
import 'list_rdv_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? "";

    final List<Widget> pages = [
      _buildCalendarPage(userId), 
      AddRdvPage(userId: userId),  // ← userId passé ici
      ListRdvPage(userId: userId), // ← userId passé ici
    ];


    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Accueil'),
      //   centerTitle: true,
      // ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Calendrier'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Ajouter'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Liste'),
        ],
      ),
    );
  }

  Widget _buildCalendarPage(String userId) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            'Accueil$userId',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Rendez-vous du ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          // À compléter : StreamBuilder pour récupérer les RDV du jour depuis Firebase
        ],
      ),
    );
  }
}