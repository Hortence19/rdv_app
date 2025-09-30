import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/rdv_ctlr.dart';
import '../models/rendez_vous.dart';

class ListRdvPage extends StatelessWidget {
  final String userId;
  const ListRdvPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final RdvController rdvController = Get.put(RdvController()); // ✅ Une seule instance

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Rendez-vous")),
      body: StreamBuilder<List<RendezVous>>(
        stream: rdvController.getUserRdvs(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Aucun rendez-vous trouvé"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // navigation vers page ajout
                    },
                    child: const Text("Ajouter un rendez-vous"),
                  )
                ],
              ),
            );
          }

          final rdvs = snapshot.data!;

          return ListView.builder(
            itemCount: rdvs.length,
            itemBuilder: (context, index) {
              final rdv = rdvs[index];
              return Dismissible(
                key: Key(rdv.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) async {
                  try {
                    await rdvController.deleteRdv(rdv.id);
                    Get.snackbar("Supprimé", "Rendez-vous supprimé ✅");
                  } catch (e) {
                    Get.snackbar("Erreur", "Impossible de supprimer ❌");
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.event, color: Colors.blue),
                    title: Text(
                      rdv.titre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${DateFormat('dd/MM/yyyy').format(rdv.date)}\n${rdv.description}",
                    ),
                    isThreeLine: true,
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