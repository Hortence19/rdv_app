import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/rdv_ctlr.dart';
import '../models/rendez_vous.dart';
import 'add_rdv_page.dart';

class ListRdvPage extends StatefulWidget {
  final String userId;
  const ListRdvPage({super.key, required this.userId});

  @override
  State<ListRdvPage> createState() => _ListRdvPageState();
}

class _ListRdvPageState extends State<ListRdvPage> {
  final RdvController rdvController = Get.put(RdvController());

  String selectedFilter = "Tous";

  List<RendezVous> _filterRdvs(List<RendezVous> rdvs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    return rdvs.where((rdv) {
      final rdvDate = DateTime(rdv.date.year, rdv.date.month, rdv.date.day);

      switch (selectedFilter) {
        case "Aujourd'hui":
          return rdvDate == today;
        case "Demain":
          return rdvDate == tomorrow;
        case "Cette semaine":
          return rdvDate.isAfter(today.subtract(const Duration(days: 1))) &&
              rdvDate.isBefore(nextWeek);
        case "Ce mois-ci":
          return rdvDate.month == now.month && rdvDate.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Rendez-vous"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "Tous", child: Text("Tous")),
              const PopupMenuItem(
                value: "Aujourd'hui",
                child: Text("Aujourd'hui"),
              ),
              const PopupMenuItem(value: "Demain", child: Text("Demain")),
              const PopupMenuItem(
                value: "Cette semaine",
                child: Text("Cette semaine"),
              ),
              const PopupMenuItem(
                value: "Ce mois-ci",
                child: Text("Ce mois-ci"),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<RendezVous>>(
        stream: rdvController.getUserRdvs(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun rendez-vous trouvé"));
          }

          final filteredRdvs = _filterRdvs(snapshot.data!);

          if (filteredRdvs.isEmpty) {
            return Center(
              child: Text("Aucun rendez-vous pour '$selectedFilter'"),
            );
          }

          return ListView.builder(
            itemCount: filteredRdvs.length,
            itemBuilder: (context, index) {
              final rdv = filteredRdvs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.deepPurple),
                  title: Text(
                    rdv.titre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${DateFormat('dd/MM/yyyy').format(rdv.date)}\n${rdv.description}",
                  ),
                  isThreeLine: true,

                  //modifier un rdv
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      Get.to(
                        () => AddRdvPage(
                          userId: widget.userId,
                          rdv: rdv, // ✅ on passe le rendez-vous existant
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
