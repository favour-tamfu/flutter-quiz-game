// lib/screens/main/quiz_screen.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../../services/database_helper.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String difficulty;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.difficulty,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;

  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;

  Timer? _timer;
  int _timeRemaining = 15;

  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();

    // **NEW LOGIC STARTS HERE**
    // Determine the number of questions based on difficulty.
    int questionLimit;
    switch (widget.difficulty) {
      case 'Easy':
        questionLimit = 3;
        break;
      case 'Normal':
        questionLimit = 5;
        break;
      case 'Hard':
        questionLimit = 10;
        break;
      default:
        questionLimit = 5; // Fallback to Normal
    }
    // **NEW LOGIC ENDS HERE**

    // Fetch the correct number of questions.
    _questionsFuture = DatabaseHelper().getQuestionsForCategory(
      widget.categoryId,
      widget.difficulty,
      limit: questionLimit, // Use our new dynamic limit
    );

    _questionsFuture.then((questions) {
      if (questions.isNotEmpty && mounted) {
        _startTimer(questions);
      }
    });
  }

  void _startTimer(List<Map<String, dynamic>> questions) {
    _timer?.cancel();
    _timeRemaining = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        if (mounted) {
          setState(() {
            _timeRemaining--;
          });
        }
      } else {
        _timer?.cancel();
        _handleAnswer(-1, questions);
      }
    });
  }

  void _handleAnswer(int selectedIndex, List<Map<String, dynamic>> questions) {
    if (_isAnswered) return;

    _timer?.cancel();
    setState(() {
      _isAnswered = true;
      _selectedAnswerIndex = selectedIndex;
    });

    final bool isCorrect = selectedIndex == questions[_currentIndex]['correct_answer_index'];

    if (isCorrect) {
      setState(() {
        _score++;
      });
    } else {
      if (_lives > 0) {
        setState(() {
          _lives--;
        });
      }
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (_lives == 0 || _currentIndex == questions.length - 1) {
        _endQuiz(questions.length);
      } else {
        if (mounted) {
          setState(() {
            _currentIndex++;
            _isAnswered = false;
            _selectedAnswerIndex = null;
          });
          _startTimer(questions);
        }
      }
    });
  }

  void _endQuiz(int totalQuestions) {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: totalQuestions,
            categoryId: widget.categoryId,
            difficulty: widget.difficulty,
          ),
        ),
      );
    }
  }

  Color _getButtonColor(int index, int correctIndex) {
    if (!_isAnswered) {
      return Theme.of(context).primaryColor;
    }
    if (index == correctIndex) {
      return Colors.green.shade700;
    } else if (index == _selectedAnswerIndex && index != correctIndex) {
      return Colors.red.shade700;
    }
    return Theme.of(context).primaryColor.withOpacity(0.5);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} - ${widget.difficulty}'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No questions found for this difficulty!\nTry another one.", textAlign: TextAlign.center,));
          }

          final questions = snapshot.data!;
          final question = questions[_currentIndex];
          final options = jsonDecode(question['options']) as List<dynamic>;
          final correctIndex = question['correct_answer_index'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: List.generate(3, (index) => Icon(
                          index < _lives ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                        ))),
                    Text('Score: $_score', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _timeRemaining / 15.0,
                      backgroundColor: Colors.grey.shade700,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    question['question_text'],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Spacer(),
                ...List.generate(options.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: _getButtonColor(index, correctIndex),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isAnswered ? null : () => _handleAnswer(index, questions),
                      child: Text(
                        options[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  );
                }),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}