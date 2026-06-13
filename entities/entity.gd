class_name Entity
extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 100

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()