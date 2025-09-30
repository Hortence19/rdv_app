import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/rdv_ctlr.dart';
import '../models/rendez_vous.dart';

class AddRdvPage extends StatefulWidget {
  final String userId;
  const AddRdvPage({super.key, required this.userId});

  @override
  State<AddRdvPage> createState() => _AddRdvPageState();
}

class _AddRdvPageState extends State<AddRdvPage> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;  // ✅ heure début
  TimeOfDay? _selectedTime2; // ✅ heure fin

  final _formKey = GlobalKey<FormState>();
  final RdvController _rdvController = RdvController();

  // Sélection de la date
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Sélection heure début
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Sélection heure fin
  Future<void> _pickTime2() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime2 = picked);
  }

  Future<void> _saveRdv() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedTime2 != null) {
      
      // Fusion date + heure début
      final startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Fusion date + heure fin
      final endDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime2!.hour,
        _selectedTime2!.minute,
      );

      final newRdv = RendezVous(
        id: const Uuid().v4(),
        titre: _titreController.text,
        description: "${_descController.text}\nDe: $startDateTime à $endDateTime",
        date: startDateTime,
        userId: widget.userId,
      );

      try {
        await _rdvController.addRdv(newRdv);

        Get.back(); // ✅ au lieu de Navigator.pop → évite écran noir
        Get.snackbar("Succès", "Rendez-vous ajouté ✅",
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar("Erreur", "Impossible d’enregistrer ❌",
            snackPosition: SnackPosition.BOTTOM);
      }
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
                decoration: const InputDecoration(labelText: "Objet"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Objet requis" : null,
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _pickDate,
                child: Text(_selectedDate == null
                    ? "Choisir une date"
                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _pickTime,
                    child: Text(_selectedTime == null
                        ? "Heure début"
                        : "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}"),
                  ),
                  TextButton(
                    onPressed: _pickTime2,
                    child: Text(_selectedTime2 == null
                        ? "Heure fin"
                        : "${_selectedTime2!.hour}:${_selectedTime2!.minute.toString().padLeft(2, '0')}"),
                  ),
                ],
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

