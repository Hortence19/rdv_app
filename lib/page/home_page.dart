import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DateTime _selectedDay = DateTime.now();

  // Simule des rendez-vous pour la démo
  final Map<DateTime, List<String>> _rdvs = {
    DateTime.utc(2025, 9, 19): ['Dentiste 10h', 'Réunion 14h'],
    DateTime.utc(2025, 9, 20): ['Coiffeur 16h'],
  };

  int _currentIndex = 0;

  List<String> get _rdvsOfSelectedDay => _rdvs[_selectedDay] ?? [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Page d'accueil avec calendrier
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
          const SizedBox(height: 16),
          Text(
            'Rendez-vous du ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ..._rdvsOfSelectedDay.map((rdv) => ListTile(title: Text(rdv))),
        ],
      ),
      // Page d'ajout (exemple simple)
      // Center(child: Text('Ajouter un rendez-vous', style: TextStyle(fontSize: 20))),
       Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Titre",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: "Date",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Heure début",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Heure fin",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            labelText: "Description",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: const Text(
            "Créer un nouveau rendez-vous",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    ),
  ),
      // Page liste de tous les rendez-vous
      ListView(
        children: _rdvs.entries.expand((entry) => entry.value.map((rdv) => ListTile(
          title: Text(rdv),
          subtitle: Text('${entry.key.day}/${entry.key.month}/${entry.key.year}'),
        ))).toList(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: SizedBox(
        height: 48, // Hauteur réduite
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() => _currentIndex = 0);
                },
                color: _currentIndex == 0 ? Theme.of(context).primaryColor : Colors.grey,
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () {
                  setState(() => _currentIndex = 2);
                },
                color: _currentIndex == 2 ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 48, width: 48,
        child: FloatingActionButton(
          onPressed: () {
            setState(() => _currentIndex = 1);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
