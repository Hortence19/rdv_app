import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rendez_vous.dart';

class RdvController {
  final CollectionReference _rdvCollection =
      FirebaseFirestore.instance.collection("rendezvous");

  // Ajouter un rendez-vous
  Future<void> addRdv(RendezVous rdv) async {
    await _rdvCollection.doc(rdv.id).set(rdv.toMap());
  }

  // Récupérer tous les rendez-vous d'un utilisateur
  Stream<List<RendezVous>> getUserRdvs(String userId) {
    return _rdvCollection
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                RendezVous.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Supprimer un rendez-vous
  Future<void> deleteRdv(String id) async {
    await _rdvCollection.doc(id).delete();
  }

  // ✅ Mettre à jour un rendez-vous existant
  Future<void> updateRdv(RendezVous rdv) async {
    await _rdvCollection.doc(rdv.id).update(rdv.toMap());
  }
}
