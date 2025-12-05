import 'package:flutter/material.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Colors')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildColorItem(
            'Primary',
            colorScheme.primary,
            colorScheme.onPrimary,
          ),
          _buildColorItem(
            'Primary Container',
            colorScheme.primaryContainer,
            colorScheme.onPrimaryContainer,
          ),
          _buildColorItem(
            'On Primary',
            colorScheme.onPrimary,
            colorScheme.primary,
          ),
          _buildColorItem(
            'On Primary Container',
            colorScheme.onPrimaryContainer,
            colorScheme.primaryContainer,
          ),
          _buildColorItem(
            'Surface',
            colorScheme.surface,
            colorScheme.onSurface,
          ),
          _buildColorItem(
            'On Surface',
            colorScheme.onSurface,
            colorScheme.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildColorItem(String name, Color color, Color textColor) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 8.0),
      color: color,
      alignment: Alignment.center,
      child: Text(
        name,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
