import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:testLast-platformer-04/analytics_service.dart';
import 'package:testLast-platformer-04/game_controller.dart';
import 'package:testLast-platformer-04/level_config.dart';

/// The main FlameGame class for the 'testLast-platformer-04' platformer game.
class testLast_platformer_04Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player's score.
  int _score = 0;

  /// The player's remaining lives.
  int _lives = 3;

  /// The current level configuration.
  LevelConfig _currentLevel;

  /// The game controller.
  final GameController _gameController;

  /// The analytics service.
  final AnalyticsService _analyticsService;

  /// Constructs a new instance of the `testLast_platformer_04Game` class.
  testLast_platformer_04Game({
    required this._gameController,
    required this._analyticsService,
  }) {
    _currentLevel = LevelConfig.fromJson(levelConfigJson);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));
    camera.followComponent(_gameController.player);
    world.gravity = Vector2(0, 1500);

    // Load the level
    await _loadLevel();

    // Add the game controller to the game
    add(_gameController);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update the game state based on the game controller
    switch (_gameController.gameState) {
      case GameControllerState.playing:
        _gameState = GameState.playing;
        break;
      case GameControllerState.paused:
        _gameState = GameState.paused;
        break;
      case GameControllerState.gameOver:
        _gameState = GameState.gameOver;
        break;
      case GameControllerState.levelComplete:
        _gameState = GameState.levelComplete;
        break;
    }

    // Update the score and lives
    _score = _gameController.score;
    _lives = _gameController.lives;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    _gameController.jump();
  }

  /// Loads the current level.
  Future<void> _loadLevel() async {
    // Load the level components from the configuration
    await _currentLevel.load(this);
  }

  /// Handles a collision between the player and an obstacle.
  void _handleCollision(CollisionComponent obstacle) {
    if (obstacle is Obstacle) {
      _gameController.takeDamage();
      _analyticsService.logEvent('level_fail');
    }
  }

  /// Handles a collision between the player and a collectible.
  void _handleCollectible(Collectible collectible) {
    _score += collectible.value;
    collectible.removeFromParent();
    _analyticsService.logEvent('collectible_picked_up');
  }

  /// Handles a collision between the player and the goal.
  void _handleGoal() {
    _gameController.completeLevel();
    _analyticsService.logEvent('level_complete');
  }
}

/// The possible game states.
enum GameState {
  playing,
  paused,
  gameOver,
  levelComplete,
}