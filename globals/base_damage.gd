class_name BaseJuice
extends Node

var base_juice = {
	0: 1,
	1: 3,
	2: 8,
	3: 20,
	4: 50,
	5: 300,
}

var juice_levels = {
	0: 0,
	1: 0,
	2: 0,
	3: 0,
	4: 0,
}

func get_damage(size):
	return base_juice[size] * (juice_levels[size] + 1)
