class_name Entity
extends CharacterBody2D

@export var speed: float = 100.0
@export var hp: int = 100
@export var blood_particles: PackedScene
@onready var stun_timer: Timer = $StunTimer
@onready var polygon2d: Polygon2D = $Polygon2D
@onready var native_color: Color = polygon2d.color
var tween: Tween

signal died

func take_damage(amount: int) -> void:
	hp -= amount
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(polygon2d, "color", Color.WHITE, 0.05)
	stun_timer.start()
	if hp <= 0:
		die()

func die() -> void:
	if NodeSpawner.node_creation_parent != null:
		var blood_particles_instance = NodeSpawner.instance_node(blood_particles, global_position, NodeSpawner.node_creation_parent)
		blood_particles_instance.color = polygon2d.color
		blood_particles_instance.rotation = velocity.angle()
	queue_free()
	emit_signal("died")

func _on_stun_timer_timeout() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(polygon2d, "color", native_color, 0.05)
