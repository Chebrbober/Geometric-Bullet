class_name Entity
extends CharacterBody2D

@export var speed: float
@export var max_health: float
@export var damage: float
@export var blood_particles: PackedScene
@onready var stun_timer: Timer = $StunTimer
@onready var polygon2d: Polygon2D = $Polygon2D
@onready var native_color: Color = polygon2d.color
@onready var blood_color: Color = polygon2d.color - Color(0.2, 0.2, 0.2, 0.1)

var tween: Tween
var current_hp: float 

func _ready() -> void:
	current_hp = max_health

func take_damage(amount: float) -> void:
	current_hp -= amount
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(polygon2d, "color", Color.WHITE, 0.05)
	stun_timer.start()
	if current_hp <= 0:
		die()

func die() -> void:
	if Global.node_creation_parent != null:
		var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
		blood_particles_instance.color = native_color
		blood_particles_instance.rotation = velocity.angle()
	Global.score += 1
	Global.score_changed.emit(Global.score)
	queue_free()

func _on_stun_timer_timeout() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(polygon2d, "color", native_color, 0.05)
