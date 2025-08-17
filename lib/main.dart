// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/user_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  // Ensures that all Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider makes the UserProvider available to all widgets below it in the tree.
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'QuizQuest',
        debugShowCheckedModeBanner: false, // Hides the debug banner in the corner

        // This is where we define the app's game-like look and feel.
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF483D8B), // A deep, mystical purple
            scaffoldBackgroundColor: const Color(0xFF121212), // A very dark background
            cardColor: const Color(0xFF1E1E1E), // Slightly lighter for cards

            // Use a cool, retro game font from Google Fonts.
            textTheme: GoogleFonts.pressStart2pTextTheme(
              ThemeData.dark().textTheme,
            ).copyWith(
              // Customize text sizes to be more readable with this font
              bodyLarge: const TextStyle(fontSize: 14, color: Colors.white70),
              bodyMedium: const TextStyle(fontSize: 12, color: Colors.white70),
              headlineSmall: const TextStyle(fontSize: 18, color: Colors.white),
              headlineMedium: const TextStyle(fontSize: 24, color: Colors.white),
              titleLarge: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            // Style all ElevatedButtons to look like primary action buttons.
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700), // A treasure-like gold
                foregroundColor: Colors.black, // Text color on the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),

            // Style all TextFormFields for a consistent look.
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFFD700)), // Gold border when selected
              ),
              labelStyle: const TextStyle(color: Colors.white70),
            )
        ),

        // The first screen the user will see.
        home: LoginScreen(),
      ),
    );
  }
}