import 'package:flutter/material.dart';

Widget IntroPage1() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset("assets/images/boarding1.png", fit: BoxFit.cover),
      const SizedBox(height: 16), // Add some space between the image and text
      const Text(
        "Caffé Praha",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      const SizedBox(height: 8), // Add some space between the heading and text
      const Text(
        "Find the best coffee for you,all you",
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 2), // Add some space between the heading and text
      const Text(
        "needs coffee ",
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}

Widget IntroPage2() {
  return Scaffold(
    body: Stack(
      children: [
        // Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/boarding2.jpeg'), // Replace 'assets/images/boarding2.jpeg' with your image path
              fit: BoxFit.fill,
            ),
          ),
        ),
        // Content
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 60),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16), // Add some space between the image and text
                Text(
                  "Customize your Coffee Experience",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center, // Align text in the center
                ),
                SizedBox(height: 8), // Add some space between the heading and text
                Text(
                  "Discover the rich flavors and aromas of our premium coffee selections. From robust espressos to smooth lattes, we offer a variety of options to suit your taste buds and elevate your coffee experience.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center, // Align text in the center
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget IntroPage3() {
  return Scaffold(
    body: Stack(
      children: [
        // Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/boarding3.jpeg'), // Replace 'assets/images/boarding3.jpeg' with your image path
              fit: BoxFit.fill,
            ),
          ),
        ),
        // Content
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16), // Add some space between the image and text
              Text(
                "your Coffee Your Way",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center, // Align text in the center
              ),
              SizedBox(height: 8), // Add some space between the heading and text
              Text(
                "Embrace the freedom to customize your coffee just the way you like it. Whether you prefer it piping hot or refreshingly cold, with a dash of milk or a hint of sweetness, our extensive menu lets you create your perfect cup every time.",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center, // Align text in the center
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
