class_name Player
extends Entity

@onready var reload_speed_timer: Timer = $ReloadSpeedTimer
@export var bullet: PackedScene

signal hp_changed(new_hp: int, max_hp: int)

var can_shoot: bool = true

func _ready() -> void:
	super._ready()
	Global.player = self

func _exit_tree() -> void:
	Global.player = null

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

	if Input.is_action_pressed("shoot") and Global.node_creation_parent != null and can_shoot:
		Global.instance_node(bullet, global_position, Global.node_creation_parent)
		reload_speed_timer.start()
		can_shoot = false
	
func _on_reload_speed_timer_timeout() -> void:
	can_shoot = true

func take_damage(amount: float) -> void:
	super.take_damage(amount)
	emit_signal("hp_changed", current_hp, max_health)


