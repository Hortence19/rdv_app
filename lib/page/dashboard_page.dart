import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime _selectedDay = DateTime.now();

  // Simule des rendez-vous pour la démo
  final Map<DateTime, List<String>> _rdvs = {
    DateTime.utc(2025, 9, 19): ['Dentiste 10h', 'Réunion 14h'],
    DateTime.utc(2025, 9, 20): ['Coiffeur 16h'],
  };

  List<String> get _rdvsOfSelectedDay => _rdvs[_selectedDay] ?? [];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Page d'accueil
      Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              // Action pour ajouter un rendez-vous
            },
            child: const Text('Ajouter un rendez-vous'),
          ),
          const SizedBox(height: 16),
          Text(
            'Rendez-vous du ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ..._rdvsOfSelectedDay.map((rdv) => ListTile(title: Text(rdv))),
        ],
      ),
      // Page liste de la journée (exemple)
      Center(child: Text('Liste des programmes de la journée')),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                setState(() => _currentIndex = 0);
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                setState(() => _currentIndex = 1);
              },
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour ajouter une tâche
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
