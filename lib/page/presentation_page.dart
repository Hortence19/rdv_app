import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rdv_app/page/connexion_page.dart';
import 'package:rdv_app/page/inscription_page.dart';

class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  final PageController _controller = PageController();

  // Liste des éléments du onboarding
  final List<Map<String, dynamic>> presentationItems = [
    {
      "icon": Icons.event_available,
      "title": "Gérez vos rendez-vous",
      "subtitle":
          "Planifiez, modifiez et suivez tous vos rendez-vous en un seul endroit, facilement et rapidement.",
    },
    {
      "icon": Icons.notifications_active,
      "title": "Notifications instantanées",
      "subtitle":
          "Recevez des rappels et des confirmations pour ne jamais manquer un rendez-vous important.",
    },
    {
      "icon": Icons.verified_user,
      "title": "Sécurité & confidentialité",
      "subtitle":
          "Vos informations et vos rendez-vous sont protégés et accessibles uniquement par vous.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Slides
          PageView.builder(
            controller: _controller,
            itemCount: presentationItems.length,
            itemBuilder: (context, index) {
              return Center(
                // <-- pour centrer la colonne
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // évite de prendre tout l’espace
                  children: [
                    Icon(
                      presentationItems[index]["icon"],
                      size: 140,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      presentationItems[index]["title"],
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        presentationItems[index]["subtitle"],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Indicateur + Boutons
          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 32, right: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: presentationItems.length,
                  effect: WormEffect(
                    dotHeight: 4,
                    dotWidth: 20,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConnexionPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Se connecter'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InscriptionPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text("S'inscrire"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
