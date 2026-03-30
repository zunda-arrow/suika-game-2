extends Node2D

var _enemies = []

func dispay_turns(enemies):
	_enemies = enemies

	$EnemyQueue.text = "\n".join(_enemies)
