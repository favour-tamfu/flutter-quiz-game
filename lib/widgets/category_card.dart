// lib/widgets/category_card.dart

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String iconPath;
  final Color color;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.iconPath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20), // Matches the container's border radius
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Note: Make sure you have the icon files in your assets/icons/ folder!
            // If the file is not found, it might show an error.
            Image.asset(
              iconPath,
              height: 40,
              // Add a fallback for the image in case it fails to load
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.help_outline, size: 40, color: Colors.white);
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 14, // Adjusted for the game font
                    shadows: [
                      const Shadow(
                        blurRadius: 2.0,
                        color: Colors.black54,
                        offset: Offset(1.0, 1.0),
                      ),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}