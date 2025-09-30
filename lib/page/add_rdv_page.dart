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
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime; // heure début
  TimeOfDay? _selectedTime2; // heure fin

  final _formKey = GlobalKey<FormState>();
  final RdvController _rdvController = RdvController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

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
      final startDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

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
        description:
            "${_descController.text}\nDe: $startDateTime à $endDateTime",
        date: startDateTime,
        userId: widget.userId,
      );

      try {
        await _rdvController.addRdv(newRdv);

        _formKey.currentState!.reset();
        _titreController.clear();
        _descController.clear();
        _dateController.clear();

        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _selectedTime2 = null;
        });

        FocusScope.of(context).unfocus();

        Get.snackbar(
          "Succès",
          "Rendez-vous ajouté ✅",
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          "Erreur",
          "Impossible d’enregistrer ❌",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "Erreur",
        "Veuillez remplir tous les champs",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Ajouter un rendez-vous",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _titreController,
                  decoration: InputDecoration(
                    hintText: "Objet",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // coins arrondis
                      borderSide: BorderSide.none, // pas de bordure visible
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Objet requis" : null,
                ),
                const SizedBox(height: 16),

                // TextFormField pour la date
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Choisir une date",
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // coins arrondis
                      borderSide: BorderSide.none, // pas de bordure visible
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Date requise" : null,
                  onTap: _pickDate,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: _pickTime,
                        child: Text(
                          _selectedTime == null
                              ? "Heure début"
                              : "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: _pickTime2,
                        child: Text(
                          _selectedTime2 == null
                              ? "Heure fin"
                              : "${_selectedTime2!.hour}:${_selectedTime2!.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // coins arrondis
                      borderSide: BorderSide.none, // pas de bordure visible
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12,
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Description requise"
                      : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    // shape: const RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.zero, // coins carrés
                    // ),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: _saveRdv,
                  child: const Text(
                    "Enregistrer",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
