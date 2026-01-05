import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';

/// The player character in the platformer game.
class Player extends SpriteAnimationComponent with KeyboardEvents, CollisionCallbacks {
  /// The player's current horizontal speed.
  double xSpeed = 0;

  /// The player's current vertical speed.
  double ySpeed = 0;

  /// The player's maximum horizontal speed.
  static const double maxXSpeed = 200;

  /// The player's maximum vertical speed.
  static const double maxYSpeed = 500;

  /// The player's horizontal acceleration.
  static const double xAcceleration = 1000;

  /// The player's vertical acceleration due to gravity.
  static const double gravity = 1500;

  /// The player's jump force.
  static const double jumpForce = -500;

  /// The player's current health.
  int health = 3;

  /// The player's current score.
  int score = 0;

  Player(Vector2 position, SpriteAnimation idleAnimation, SpriteAnimation walkingAnimation, SpriteAnimation jumpingAnimation)
      : super(
          position: position,
          size: Vector2.all(32),
          animation: idleAnimation,
        ) {
    animations = {
      'idle': idleAnimation,
      'walking': walkingAnimation,
      'jumping': jumpingAnimation,
    };
    currentAnimation = 'idle';
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    ySpeed += gravity * dt;
    ySpeed = ySpeed.clamp(-maxYSpeed, maxYSpeed);

    // Apply horizontal movement
    if (isPressed(LogicalKeyboardKey.arrowLeft)) {
      xSpeed = -maxXSpeed;
      flipHorizontally();
    } else if (isPressed(LogicalKeyboardKey.arrowRight)) {
      xSpeed = maxXSpeed;
      flipHorizontally(flip: false);
    } else {
      xSpeed = 0;
    }

    // Apply vertical movement
    if (isPressed(LogicalKeyboardKey.arrowUp) && ySpeed >= 0) {
      ySpeed = jumpForce;
      currentAnimation = 'jumping';
    }

    // Update position
    position.add(Vector2(xSpeed * dt, ySpeed * dt));

    // Update animation
    if (xSpeed != 0) {
      currentAnimation = 'walking';
    } else {
      currentAnimation = 'idle';
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Handle collisions with enemies or obstacles
    if (other is Enemy) {
      takeDamage(1);
    }
  }

  /// Reduces the player's health by the specified amount.
  void takeDamage(int amount) {
    health -= amount;
    if (health <= 0) {
      // Player has died, handle game over logic
    }
  }

  /// Increases the player's score by the specified amount.
  void addScore(int amount) {
    score += amount;
  }
}