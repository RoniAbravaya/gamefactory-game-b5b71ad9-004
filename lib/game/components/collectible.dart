import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/audio.dart';
import 'package:flutter/material.dart';

/// A collectible item component for a platformer game.
class Collectible extends SpriteComponent with CollisionCallbacks {
  final int scoreValue;
  final Audio _collectSound;

  /// Creates a new Collectible component.
  ///
  /// [sprite] is the sprite to be displayed for the collectible.
  /// [position] is the initial position of the collectible.
  /// [scoreValue] is the score value awarded when the collectible is collected.
  /// [collectSound] is the audio to be played when the collectible is collected.
  Collectible({
    required Sprite sprite,
    required Vector2 position,
    required this.scoreValue,
    required Audio collectSound,
  })  : _collectSound = collectSound,
        super(
          position: position,
          size: Vector2.all(32.0),
          sprite: sprite,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addCollision();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    _handleCollect();
  }

  void _handleCollect() {
    // Trigger score update and play collect sound
    _collectSound.play();
    removeFromParent();
  }

  /// Adds an optional animation to the collectible, such as spinning or floating.
  void addAnimation() {
    // Implement animation logic here
  }
}