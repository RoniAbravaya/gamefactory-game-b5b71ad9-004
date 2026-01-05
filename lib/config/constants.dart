import 'package:flutter/material.dart';

/// Game constants and configuration values
/// 
/// Contains colors, dimensions, and other constant values.

class GameConstants {
  // Game settings
  static const int totalLevels = 10;
  static const int freeLevels = 3;
  static const int startingLives = 3;
  
  // Timing
  static const double gameTickRate = 60.0;
  static const Duration levelTransitionDuration = Duration(milliseconds: 500);
  
  // Game dimensions (logical pixels)
  static const double gameWidth = 400;
  static const double gameHeight = 800;
  
  // Player
  static const double playerWidth = 50;
  static const double playerHeight = 50;
  static const double playerSpeed = 200;
  static const double jumpForce = 400;
  
  // Obstacles
  static const double minObstacleGap = 150;
  static const double maxObstacleSpeed = 300;
  
  // Collectibles
  static const int coinValue = 10;
  static const int starValue = 50;
}

class GameColors {
  // Primary palette from GDD
  static const Color primary = Color(0xFFFFB5B5);
  static const Color secondary = Color(0xFFB5D8FF);
  static const Color accent = Color(0xFFB5FFB5);
  static const Color success = Color(0xFFFFE5B5);
  static const Color warning = Color(0xFFE5B5FF);
  
  // UI colors
  static const Color background = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFF16213E);
  static const Color text = Color(0xFFE8E8E8);
  static const Color textSecondary = Color(0xFFB0B0B0);
}
