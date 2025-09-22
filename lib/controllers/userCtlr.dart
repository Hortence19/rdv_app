import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/route_manager.dart';
import 'package:rdv_app/models/my_user.dart';

class UserController {
  var userDb = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(MyUser user) async {
    // Logic to create a user
    try {
      await userDb.add(user.toJson());
    } on Exception catch (e) {
      // log(e);
      Get.snackbar(
        'Une erreur est survenue',
        "Veuillez ressayer ultérieurement. Contactez le support si le problème persiste.\n",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<MyUser> getUserById(String id) async {
    var data = await userDb.doc(id).get();
    MyUser user = MyUser.fromSnapshot(data as DocumentSnapshot<Object?>);
    return user;
  }

  Future<List<MyUser>> getAllUsers() async {
    var data = await userDb.get();
    var users = data.docs.map((e) => MyUser.fromSnapshot(e)).toList();
    return users;
  }

  Future<void> updateUser(MyUser user) async {
    // Logic to update a user
    try {
      await userDb.doc(user.id).update(user.toJson());
    } on Exception catch (e) {
      // log(e);
      Get.snackbar(
        'Une erreur est survenue',
        "Veuillez ressayer ultérieurement. Contactez le support si le problème persiste.\n",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateUserByKeys(String id, Map<String, dynamic> data) async {
    // Logic to update a user
    try {
      await userDb.doc(id).update(data);
    } on Exception catch (e) {
      // log(e);
      Get.snackbar(
        'Une erreur est survenue',
        "Veuillez ressayer ultérieurement. Contactez le support si le problème persiste.\n",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
