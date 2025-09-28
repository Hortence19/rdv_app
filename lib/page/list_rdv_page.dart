// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../controllers/rdv_ctlr.dart';
// import '../models/rendez_vous.dart';

// class ListRdvPage extends StatelessWidget {
//   final String userId;
//   const ListRdvPage({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     final RdvController rdvController = RdvController();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Liste des Rendez-vous")),
//       body: StreamBuilder<List<RendezVous>>(
//         stream: rdvController.getUserRdvs(userId),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

//           final rdvs = snapshot.data!;
//           if (rdvs.isEmpty) return const Center(child: Text("Aucun rendez-vous"));

//           return ListView.builder(
//             itemCount: rdvs.length,
//             itemBuilder: (context, index) {
//               final rdv = rdvs[index];
//               return Dismissible(
//                 key: Key(rdv.id),
//                 background: Container(color: Colors.red),
//                 onDismissed: (_) => rdvController.deleteRdv(rdv.id),
//                 child: Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   child: ListTile(
//                     leading: const Icon(Icons.event),
//                     title: Text(rdv.titre),
//                     subtitle: Text(
//                       "${DateFormat('dd/MM/yyyy – HH:mm').format(rdv.date)}\n${rdv.description}",
//                     ),
//                     isThreeLine: true,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/rdv_ctlr.dart';
import '../models/rendez_vous.dart';

class ListRdvPage extends StatelessWidget {
  final String userId;
  const ListRdvPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final RdvController rdvController = RdvController();

    return Scaffold(
      appBar: AppBar(title: const Text("Liste des Rendez-vous")),
      body: StreamBuilder<List<RendezVous>>(
        stream: rdvController.getUserRdvs(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final rdvs = snapshot.data!;
          if (rdvs.isEmpty) return const Center(child: Text("Aucun rendez-vous"));

          return ListView.builder(
            itemCount: rdvs.length,
            itemBuilder: (context, index) {
              final rdv = rdvs[index];
              return Dismissible(
                key: Key(rdv.id),
                background: Container(color: Colors.red),
                onDismissed: (_) => rdvController.deleteRdv(rdv.id),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(rdv.titre),
                    subtitle: Text(
                      "${DateFormat('dd/MM/yyyy – HH:mm').format(rdv.date)}\n${rdv.description}",
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

