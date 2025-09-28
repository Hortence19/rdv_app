import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'connexion_page.dart';
import 'inscription_page.dart';

class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  final PageController _controller = PageController();

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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: presentationItems.length,
            itemBuilder: (context, index) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        presentationItems[index]["icon"],
                        size: screenHeight * 0.2,
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                        child: Text(
                          presentationItems[index]["title"],
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: screenHeight * 0.03,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                        child: Text(
                          presentationItems[index]["subtitle"],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: screenHeight * 0.02),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: screenHeight * 0.05, left: screenWidth * 0.08, right: screenWidth * 0.08),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: presentationItems.length,
                  effect: WormEffect(
                    dotHeight: screenHeight * 0.005,
                    dotWidth: screenWidth * 0.05,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
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
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                      textStyle: TextStyle(fontSize: screenHeight * 0.022),
                    ),
                    child: const Text('Se connecter'),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
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
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                      textStyle: TextStyle(fontSize: screenHeight * 0.022),
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

