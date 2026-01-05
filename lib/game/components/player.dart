import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:testLast-platformer-04/game_objects/obstacle.dart';
import 'package:testLast-platformer-04/game_objects/collectable.dart';

/// The Player component for the platformer game.
class Player extends SpriteAnimationComponent with HasHitboxes, Collidable {
  static const double _playerSpeed = 200.0;
  static const double _playerJumpForce = 500.0;
  static const double _playerGravity = 1200.0;

  double _velocity = 0.0;
  double _health = 100.0;
  double _invulnerabilityTime = 0.0;

  /// The current animation state of the player.
  PlayerAnimationState _currentAnimationState = PlayerAnimationState.idle;

  /// Creates a new instance of the Player component.
  Player(Vector2 position) : super(position: position, size: Vector2.all(50.0)) {
    addHitbox(HitboxRectangle());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadAnimations();
    animation = _getAnimation(PlayerAnimationState.idle);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update player movement
    _updateMovement(dt);

    // Update player animation
    _updateAnimation(dt);

    // Update player health and invulnerability
    _updateHealth(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);

    if (other is Obstacle) {
      // Handle collision with obstacles
      _handleObstacleCollision(other);
    } else if (other is Collectable) {
      // Handle collision with collectables
      _handleCollectableCollision(other);
    }
  }

  /// Moves the player based on user input.
  void moveLeft() {
    _currentAnimationState = PlayerAnimationState.running;
    x -= _playerSpeed * dt;
  }

  /// Moves the player based on user input.
  void moveRight() {
    _currentAnimationState = PlayerAnimationState.running;
    x += _playerSpeed * dt;
  }

  /// Jumps the player.
  void jump() {
    if (_velocity == 0.0) {
      _velocity = -_playerJumpForce;
      _currentAnimationState = PlayerAnimationState.jumping;
    }
  }

  /// Handles the collision with an obstacle.
  void _handleObstacleCollision(Obstacle obstacle) {
    // Resolve the collision and update the player's position
    position = position.clone();
  }

  /// Handles the collision with a collectable.
  void _handleCollectableCollision(Collectable collectable) {
    // Collect the collectable and update the game state
    collectable.collect();
  }

  /// Updates the player's movement based on gravity and user input.
  void _updateMovement(double dt) {
    // Apply gravity
    _velocity += _playerGravity * dt;
    y += _velocity * dt;

    // Clamp the player's position to the screen bounds
    position.clamp(
      Vector2.zero(),
      size: game.size - Vector2.all(size.x),
    );
  }

  /// Updates the player's animation based on the current state.
  void _updateAnimation(double dt) {
    animation = _getAnimation(_currentAnimationState);
  }

  /// Updates the player's health and invulnerability.
  void _updateHealth(double dt) {
    // Decrease invulnerability time
    _invulnerabilityTime = (_invulnerabilityTime - dt).clamp(0.0, double.infinity);

    // TODO: Implement damage and health system
  }

  /// Loads the player's animations.
  Future<void> _loadAnimations() async {
    // TODO: Load the player's animation sprites
  }

  /// Returns the appropriate animation for the current state.
  SpriteAnimation _getAnimation(PlayerAnimationState state) {
    // TODO: Return the appropriate animation for the given state
    return _idleAnimation;
  }
}

/// The possible animation states for the player.
enum PlayerAnimationState {
  idle,
  running,
  jumping,
  hurt,
}