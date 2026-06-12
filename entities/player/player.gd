extends CharacterBody2D

@export var bullet: PackedScene
@onready var reload_speed_timer: Timer = $ReloadSpeedTimer
const SPEED = 100.0
var can_shoot = true

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()

	if Input.is_action_pressed("shoot") and NodeSpawner.node_creation_parent != null and can_shoot:
		NodeSpawner.instance_node(bullet, global_position, NodeSpawner.node_creation_parent)
		reload_speed_timer.start()
		can_shoot = false



func _on_reload_speed_timeout() -> void:
	can_shoot = true
