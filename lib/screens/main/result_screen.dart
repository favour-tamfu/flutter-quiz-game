// lib/screens/main/result_screen.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../services/database_helper.dart';
import '../../services/user_provider.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int categoryId;
  final String difficulty;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.categoryId,
    required this.difficulty,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  void initState() {
    super.initState();
    _saveResults();
  }

  void _saveResults() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      await DatabaseHelper().saveResult(user.id, widget.categoryId, widget.score, widget.totalQuestions);

      double multiplier = 1.0;
      switch (widget.difficulty) {
        case 'Normal':
          multiplier = 1.5;
          break;
        case 'Hard':
          multiplier = 2.0;
          break;
      }

      int xpGained = (widget.score * 10 * multiplier).toInt();
      await DatabaseHelper().updateUserXp(user.id, xpGained);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isGoodScore = (widget.score / widget.totalQuestions) >= 0.6;
    final String lottieAsset = isGoodScore
        ? 'assets/animations/confetti.json'
        : 'assets/animations/fail.json';

    double multiplier = 1.0;
    switch (widget.difficulty) {
      case 'Normal':
        multiplier = 1.5;
        break;
      case 'Hard':
        multiplier = 2.0;
        break;
    }
    int xpGained = (widget.score * 10 * multiplier).toInt();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottieAsset,
                repeat: false,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error_outline, size: 200);
                },
              ),
              const SizedBox(height: 20),

              Text(
                'Quest Complete!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFFFFD700),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'You scored',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '${widget.score} / ${widget.totalQuestions}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                '+$xpGained XP',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.greenAccent,
                ),
              ),
              if (multiplier > 1.0)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '(${widget.difficulty} Bonus x$multiplier)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.greenAccent.withOpacity(0.8)),
                  ),
                ),
              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text('RETURN TO LOBBY'),
              )
            ],
          ),
        ),
      ),
    );
  }
}