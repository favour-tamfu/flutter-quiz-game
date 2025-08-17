// lib/screens/main/profile_screen.dart

import 'dart:math'; // Import the math library for the 'max' function
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/database_helper.dart';
import '../../services/user_provider.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = DatabaseHelper().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${user.pseudoName}\'s Progress'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(user.pseudoName, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(user.email, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                return DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Select a Quest to see progress',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategoryId,
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedCategoryId = newValue;
                    });
                  },
                  items: snapshot.data!.map((category) {
                    return DropdownMenuItem<int>(
                      value: category['id'],
                      child: Text(category['name']),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                ),
                child: _selectedCategoryId != null
                    ? PerformanceChart(
                  userId: user.id,
                  categoryId: _selectedCategoryId!,
                )
                    : const Center(
                  child: Text("Select a category to view your progress chart."),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PerformanceChart extends StatelessWidget {
  final int userId;
  final int categoryId;

  const PerformanceChart({super.key, required this.userId, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getResultsForUser(userId, categoryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data yet. Play a quiz in this category!"));
        }

        final results = snapshot.data!;
        final spots = <FlSpot>[];
        for (int i = 0; i < results.length; i++) {
          spots.add(FlSpot(i.toDouble(), results[i]['score'].toDouble()));
        }

        // **NEW LOGIC**: Dynamically calculate the maximum possible score for the Y-axis.
        double maxScore = 5.0; // Default fallback
        if (results.isNotEmpty) {
          // Find the highest 'total_questions' value among the results.
          final maxPossibleScore = results.map<int>((r) => r['total_questions']).reduce(max);
          maxScore = maxPossibleScore.toDouble();
        }

        return Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
                getDrawingVerticalLine: (value) => const FlLine(color: Colors.white10, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) => Text('  Try ${value.toInt() + 1}', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.white10)),
              minX: 0,
              maxX: (spots.length - 1).toDouble(),
              minY: 0,
              maxY: maxScore, // Use the dynamic max score here
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: const LinearGradient(colors: [Color(0xFF483D8B), Color(0xFFFFD700)]),
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [Color(0xFF483D8B).withOpacity(0.3), Color(0xFFFFD700).withOpacity(0.3)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}