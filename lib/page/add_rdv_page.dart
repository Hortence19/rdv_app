// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';
// import '../controllers/rdv_ctlr.dart';
// import '../models/rendez_vous.dart';

// class AddRdvPage extends StatefulWidget {
//   const AddRdvPage({super.key});

//   @override
//   State<AddRdvPage> createState() => _AddRdvPageState();
// }

// class _AddRdvPageState extends State<AddRdvPage> {
//   final TextEditingController titleCtrl = TextEditingController();
//   final TextEditingController descCtrl = TextEditingController();
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   final RdvController rdvController = RdvController();
//   final User? user = FirebaseAuth.instance.currentUser;

//   Future<void> _pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2050),
//       initialDate: DateTime.now(),
//     );
//     if (picked != null) setState(() => selectedDate = picked);
//   }

//   Future<void> _pickTime() async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) setState(() => selectedTime = picked);
//   }

//   void _saveRdv() async {
//     if (titleCtrl.text.isEmpty || selectedDate == null || selectedTime == null) {
//       Get.snackbar("Erreur", "Veuillez remplir tous les champs",
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }

//     final dateTime = DateTime(
//       selectedDate!.year,
//       selectedDate!.month,
//       selectedDate!.day,
//       selectedTime!.hour,
//       selectedTime!.minute,
//     );

//     final rdv = RendezVous(
//       id: const Uuid().v4(),
//       titre: titleCtrl.text,
//       description: descCtrl.text,
//       date: dateTime,
//       userId: user!.uid,
//     );

//     await rdvController.addRdv(rdv);
//     Get.back(); // revient à la page précédente
//     Get.snackbar("Succès", "Rendez-vous ajouté ✅",
//         snackPosition: SnackPosition.BOTTOM);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Ajouter un Rendez-vous")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Titre")),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _pickDate,
//               child: Text(selectedDate == null
//                   ? "Choisir une date"
//                   : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _pickTime,
//               child: Text(selectedTime == null
//                   ? "Choisir l’heure"
//                   : selectedTime!.format(context)),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: descCtrl,
//               maxLines: 3,
//               decoration: const InputDecoration(labelText: "Description"),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _saveRdv,
//               child: const Text("Enregistrer"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../controllers/rdv_ctlr.dart';
import '../models/rendez_vous.dart';

class AddRdvPage extends StatefulWidget {
  // const AddRdvPage({super.key});
  final String userId;  // ← ajouté
  const AddRdvPage({super.key, required this.userId});  // ← constructeur mis à jour

  @override
  State<AddRdvPage> createState() => _AddRdvPageState();
}

class _AddRdvPageState extends State<AddRdvPage> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final RdvController rdvController = RdvController();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _saveRdv() async {
    if (titleCtrl.text.isEmpty || selectedDate == null || selectedTime == null) {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final rdv = RendezVous(
      id: const Uuid().v4(),
      titre: titleCtrl.text,
      description: descCtrl.text,
      date: dateTime,
      userId: widget.userId,
    );

    await rdvController.addRdv(rdv);
    Get.back(); // revient à la page précédente
    Get.snackbar("Succès", "Rendez-vous ajouté ✅",
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un Rendez-vous")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Titre")),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(selectedDate == null
                  ? "Choisir une date"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(selectedTime == null
                  ? "Choisir l’heure"
                  : selectedTime!.format(context)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveRdv,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
