class_name BaseJuice
extends Node

# Multipy the base damage by this number^2. Upgrading incraeses by base value.
var base_juice = {
	0: 1,
	1: 2,
	2: 3,
	3: 4,
	4: 5,
	5: 6,
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
