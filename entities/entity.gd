class_name Entity
extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 100
@export var blood_particles: PackedScene
@onready var stun_timer: Timer = $StunTimer
var native_modulate: Color = modulate

signal died

func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		die()
	modulate = Color.WHITE
	stun_timer.start()

func die() -> void:
	if NodeSpawner.node_creation_parent != null:
		var blood_particles_instance = NodeSpawner.instance_node(blood_particles, global_position, NodeSpawner.node_creation_parent)
		blood_particles_instance.rotation = velocity.angle()
	queue_free()
	emit_signal("died")

func _on_stun_timer_timeout() -> void:
	modulate = native_modulate
