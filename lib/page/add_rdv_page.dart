import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../controllers/rdv_ctlr.dart';
import '../models/rendez_vous.dart';

class AddRdvPage extends StatefulWidget {
  final String userId;
  final RendezVous? rdv; // ✅ optionnel pour edit

  const AddRdvPage({super.key, required this.userId, this.rdv});

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

  @override
  void initState() {
    super.initState();

    // ✅ si rdv existe → on pré-remplit
    if (widget.rdv != null) {
      _titreController.text = widget.rdv!.titre;
      _descController.text = widget.rdv!.description;

      _selectedDate = widget.rdv!.date;
      _dateController.text =
          "${_selectedDate!.day.toString().padLeft(2, '0')}/"
          "${_selectedDate!.month.toString().padLeft(2, '0')}/"
          "${_selectedDate!.year}";

      // heure début = heure de la date
      _selectedTime = TimeOfDay.fromDateTime(widget.rdv!.date);

      // pour simplifier, je mets heure fin = heure début + 1h
      _selectedTime2 = TimeOfDay(
        hour: (_selectedTime!.hour + 1) % 24,
        minute: _selectedTime!.minute,
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      initialDate: _selectedDate ?? DateTime.now(),
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
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _pickTime2() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime2 ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime2 = picked);
  }

  Future<void> _saveOrUpdateRdv() async {
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

      // ✅ si rdv existe → on garde son id
      final rdvToSave = RendezVous(
        id: widget.rdv?.id ?? const Uuid().v4(),
        titre: _titreController.text,
        description:
            "${_descController.text}\nDe: $startDateTime à $endDateTime",
        date: startDateTime,
        userId: widget.userId,
      );

      try {
        if (widget.rdv == null) {
          await _rdvController.addRdv(rdvToSave);
          Get.snackbar(
            "Succès",
            "Rendez-vous ajouté ✅",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          await _rdvController.updateRdv(rdvToSave); // ⚡ update ici
          Get.snackbar(
            "Succès",
            "Rendez-vous modifié ✏️",
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        Get.back(); // on revient à la liste
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
      appBar: AppBar(
        title: Text(
          widget.rdv == null
              ? "Ajouter un rendez-vous"
              : "Modifier un rendez-vous",
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titreController,
                  decoration: InputDecoration(
                    hintText: "Objet",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
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
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
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
                        onPressed: _pickTime,
                        child: Text(
                          _selectedTime == null
                              ? "Heure début"
                              : "${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _pickTime2,
                        child: Text(
                          _selectedTime2 == null
                              ? "Heure fin"
                              : "${_selectedTime2!.hour}:${_selectedTime2!.minute.toString().padLeft(2, '0')}",
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
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
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
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: _saveOrUpdateRdv,
                  child: Text(
                    widget.rdv == null ? "Enregistrer" : "Mettre à jour",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
