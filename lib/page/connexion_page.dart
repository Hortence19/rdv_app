// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rdv_app/page/dashboard_page.dart'

// class ConnexionPage extends StatefulWidget {
//   const ConnexionPage({super.key});

//   @override
//   State<ConnexionPage> createState() => _ConnexionPageState();
// }

// class _ConnexionPageState extends State<ConnexionPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String? errorMessage;

//   Future<void> signIn() async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//       if (!mounted) return; // Ajouté pour éviter l'erreur
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Connexion réussie !')));
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const DashboardPage()),
//       );
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         errorMessage = e.message;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Connexion')),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: 'Mot de passe'),
//               obscureText: true,
//             ),
//             if (errorMessage != null) ...[
//               const SizedBox(height: 16),
//               Text(errorMessage!, style: const TextStyle(color: Colors.red)),
//             ],
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: signIn,
//                 child: const Text('Se connecter'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:rdv_app/page/dashboard_page.dart';

class ConnexionPage extends StatelessWidget {
  const ConnexionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
          child: const Text('Aller au dashboard'),
        ),
      ),
    );
  }
}
