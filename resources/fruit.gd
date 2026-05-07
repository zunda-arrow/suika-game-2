class_name FruitResouce
extends Resource

@export var fruit_name: String
@export_multiline var fruit_description: String
@export var texture: Texture2D
@export var extra_damage: int
@export var extra_hits: int
@export var behavior: Behavior

enum FruitTarget {
	Random,
	Strongest,
	Weakest,
}

@export var target_type: FruitTarget = FruitTarget.Random

enum Behavior {
	Default,
}

class Fruit extends Node:
	var fruit_name: String
	var target_type: FruitTarget
	var extra_damage: int
	var extra_hits: int
	var texture: Texture2D
	var behavior: DefaultFruitBehavior

class DefaultFruitBehavior:
	pass

var all_behaviors = {
	Behavior.Default: DefaultFruitBehavior,
}

func new() -> Fruit:
	var fruit = Fruit.new()
	fruit.fruit_name = fruit_name
	fruit.target_type = target_type
	fruit.extra_damage = extra_damage
	fruit.extra_hits = extra_hits
	fruit.texture = texture
	fruit.behavior = all_behaviors[behavior].new()
	return fruit
