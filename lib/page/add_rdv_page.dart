import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../controllers/rdv_ctlr.dart';
import '../models/rendez_vous.dart';

class AddRdvPage extends StatefulWidget {
  final String userId; // ✅ on reçoit bien l'userId
  const AddRdvPage({super.key, required this.userId});

  @override
  State<AddRdvPage> createState() => _AddRdvPageState();
}

class _AddRdvPageState extends State<AddRdvPage> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _selectedDate;
  final _formKey = GlobalKey<FormState>();

  final RdvController _rdvController = RdvController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _saveRdv() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newRdv = RendezVous(
        id: const Uuid().v4(), // ID unique
        titre: _titreController.text,
        description: _descController.text,
        date: _selectedDate!,
        userId: widget.userId, // ✅ userId bien lié
      );

      print("DEBUG: Ajout rdv pour userId=${widget.userId}");

      await _rdvController.addRdv(newRdv);

      Navigator.pop(context); // Retour à la liste
      Get.snackbar("Succès", "Rendez-vous ajouté ✅",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Erreur", "Veuillez remplir tous les champs",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un Rendez-vous")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: "Titre"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Titre requis" : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickDate,
                child: Text(_selectedDate == null
                    ? "Choisir une date"
                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Description requise" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveRdv,
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

