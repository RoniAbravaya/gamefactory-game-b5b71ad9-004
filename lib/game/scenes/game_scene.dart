import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:testLast-platformer-04/player.dart';
import 'package:testLast-platformer-04/obstacle.dart';
import 'package:testLast-platformer-04/collectable.dart';

/// The main game scene that handles level setup, game loop, and UI.
class GameScene extends FlameGame with TapDetector {
  /// The player character.
  late Player player;

  /// The obstacles in the level.
  final List<Obstacle> _obstacles = [];

  /// The collectables in the level.
  final List<Collectable> _collectables = [];

  /// The current score.
  int _score = 0;

  /// Loads the level and sets up the game scene.
  @override
  Future<void> onLoad() async {
    try {
      // Load level data
      await _loadLevel();

      // Add player, obstacles, and collectables to the scene
      add(player);
      _obstacles.forEach(add);
      _collectables.forEach(add);
    } catch (e) {
      // Handle any errors that occur during level loading
      print('Error loading game scene: $e');
    }
  }

  /// Handles the game loop logic, including win/lose conditions.
  @override
  void update(double dt) {
    super.update(dt);

    try {
      // Check for player collisions with obstacles or collectables
      _checkCollisions();

      // Check for win/lose conditions
      _checkGameState();
    } catch (e) {
      // Handle any errors that occur during the game loop
      print('Error updating game scene: $e');
    }
  }

  /// Handles the user tapping the screen to jump.
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    player.jump();
  }

  /// Pauses the game.
  void pause() {
    pauseEngine();
  }

  /// Resumes the game.
  void resume() {
    resumeEngine();
  }

  /// Loads the level data and sets up the game scene.
  Future<void> _loadLevel() async {
    // Load level data from a file or database
    final levelData = await _loadLevelData();

    // Spawn the player
    player = Player(levelData.playerStartPosition);

    // Spawn obstacles
    for (final obstacleData in levelData.obstacles) {
      _obstacles.add(Obstacle(obstacleData.position, obstacleData.size));
    }

    // Spawn collectables
    for (final collectableData in levelData.collectables) {
      _collectables.add(Collectable(collectableData.position, collectableData.value));
    }
  }

  /// Checks for collisions between the player and obstacles or collectables.
  void _checkCollisions() {
    // Check for collisions with obstacles
    for (final obstacle in _obstacles) {
      if (player.isColliding(obstacle)) {
        // Player has collided with an obstacle, handle the loss condition
        _handleLoss();
        return;
      }
    }

    // Check for collisions with collectables
    for (final collectable in _collectables) {
      if (player.isColliding(collectable)) {
        // Player has collected a collectable, update the score
        _collectCollectable(collectable);
      }
    }
  }

  /// Checks the game state and handles win/lose conditions.
  void _checkGameState() {
    // Check if the player has reached the goal
    if (player.hasReachedGoal()) {
      // Player has completed the level, handle the win condition
      _handleWin();
    }
  }

  /// Handles the player losing the game.
  void _handleLoss() {
    // Implement game over logic, such as displaying a game over screen
    print('Player has lost the game.');
  }

  /// Handles the player winning the game.
  void _handleWin() {
    // Implement level completion logic, such as displaying a victory screen
    print('Player has won the game!');
  }

  /// Collects a collectable and updates the score.
  void _collectCollectable(Collectable collectable) {
    // Update the score
    _score += collectable.value;

    // Remove the collectable from the scene
    remove(collectable);
  }

  /// Loads the level data from a file or database.
  Future<LevelData> _loadLevelData() async {
    // Implement level data loading logic
    return LevelData(
      playerStartPosition: Vector2(100, 400),
      obstacles: [
        ObstacleData(position: Vector2(200, 500), size: Vector2(50, 50)),
        ObstacleData(position: Vector2(400, 450), size: Vector2(75, 75)),
      ],
      collectables: [
        CollectableData(position: Vector2(300, 400), value: 10),
        CollectableData(position: Vector2(500, 350), value: 20),
      ],
    );
  }
}

/// Represents the data for a single level.
class LevelData {
  final Vector2 playerStartPosition;
  final List<ObstacleData> obstacles;
  final List<CollectableData> collectables;

  LevelData({
    required this.playerStartPosition,
    required this.obstacles,
    required this.collectables,
  });
}

/// Represents the data for a single obstacle.
class ObstacleData {
  final Vector2 position;
  final Vector2 size;

  ObstacleData({
    required this.position,
    required this.size,
  });
}

/// Represents the data for a single collectable.
class CollectableData {
  final Vector2 position;
  final int value;

  CollectableData({
    required this.position,
    required this.value,
  });
}