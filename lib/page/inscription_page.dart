import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rdv_app/controllers/userCtlr.dart';
import 'package:rdv_app/models/my_user.dart';
import 'package:rdv_app/page/connexion_page.dart';
import 'package:rdv_app/utils/utils.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController lastnameCtrl = TextEditingController();
  final TextEditingController firstnameCtrl = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserController userController = UserController();

  final formKey = GlobalKey<FormState>();
  bool isObscured = true;

  void togglePassword() {
    setState(() => isObscured = !isObscured);
  }

  void saveUserToFirebase() async {
    MyUser userToSave = MyUser(
      fname: firstnameCtrl.text,
      lname: lastnameCtrl.text,
      email: emailController.text,
      password: MyUtils().hashPswd(passwordController.text),
    );

    await userController.createUser(userToSave);

    emailController.clear();
    passwordController.clear();
    lastnameCtrl.clear();
    firstnameCtrl.clear();

    Get.offAll(() => ConnexionPage());

    Get.snackbar(
      'Information',
      "Inscription réussie",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          // permet de scroller si le clavier s'affiche
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre
                const Text(
                  "Inscription",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Bienvenue sur votre application.",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: lastnameCtrl,
                  decoration: InputDecoration(
                    hintText: "Nom",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: firstnameCtrl,
                  decoration: InputDecoration(
                    hintText: "Prenoms",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Champ email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Saisissez votre email SVP';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Adresse email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Champ mot de passe
                TextFormField(
                  controller: passwordController,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      onPressed: togglePassword,
                      icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Saisissez votre mot de passe SVP'
                      : null,
                ),
                const SizedBox(height: 30),

                // Bouton Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      saveUserToFirebase();
                    } else {
                      Get.snackbar(
                        'Information',
                        "Formulaire invalide",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),

                // Boutons Google et
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(60),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Image.asset(
                          "assets/google.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(60),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: Image.asset(
                          "assets/facebook.png",
                          width: 40,
                          height: 40,
                          scale: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
