class_name FruitResouce
extends Resource

@export var fruit_name: String
@export_multiline var fruit_description: String
@export var texture: Texture2D
@export var damage: int
@export var hits: int
@export var behavior: Behavior

enum FruitTarget {
	Random,
	Strongest,
	Weakest,
}

@export var target_type: FruitTarget = FruitTarget.Random

enum Behavior {
	Default,
	AttackOnce,
	RandomFruitAttacks,
}

class Fruit extends Node:
	var fruit_name: String
	var target_type: FruitTarget
	var damage: int
	var hits: int
	var texture: Texture2D
	var behavior: DefaultFruitBehavior

class DefaultFruitBehavior:
	# This triggers on merge
	func passive(_game: Game, _fruit: PlayerBall):
		return null

class AttackOnce extends DefaultFruitBehavior:
	func passive(game: Game, fruit: PlayerBall):
		game.create_attack_from_fruit(fruit)

# Two random fruits trigger passive
class RandomFruitAttacks extends  DefaultFruitBehavior:
	func passive(game: Game, _fruit: PlayerBall):
		var fruits = game.get_fruits()
		fruits.shuffle()
		var two_fruits = fruits.slice(0, 2)
		for fruit in two_fruits:
			game.create_attack_from_fruit(fruit)


var all_behaviors = {
	Behavior.Default: DefaultFruitBehavior,
	Behavior.AttackOnce: AttackOnce,
	Behavior.RandomFruitAttacks: RandomFruitAttacks,
}

func new() -> Fruit:
	var fruit = Fruit.new()
	fruit.fruit_name = fruit_name
	fruit.target_type = target_type
	fruit.damage = damage
	fruit.hits = hits
	fruit.texture = texture
	fruit.behavior = all_behaviors[behavior].new()
	return fruit
