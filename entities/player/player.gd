class_name Player
extends Entity

@onready var reload_speed_timer: Timer = $ReloadSpeedTimer
@onready var regeneration_timer: Timer = $RegenerationTimer
@export var bullet: PackedScene
var regeneration_amount: float = 1

signal hp_changed(new_hp: int, max_hp: int)

var can_shoot: bool = true

func _ready() -> void:
	super._ready()
	Global.player = self

func _exit_tree() -> void:
	Global.player = null

func _physics_process(_delta: float) -> void:
	move()
	update_rotation()
	if Input.is_action_pressed("shoot") and Global.node_creation_parent != null and can_shoot:
		shoot()

func move() -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

func shoot() -> void:
	Global.instance_node(bullet, global_position, Global.node_creation_parent)
	reload_speed_timer.start()
	can_shoot = false

func update_rotation() -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	rotation = (mouse_position - global_position).angle()
	
func _on_reload_speed_timer_timeout() -> void:
	can_shoot = true

func take_damage(amount: float) -> void:
	super.take_damage(amount)
	emit_signal("hp_changed", current_hp, max_health)

func _on_regeneration_timer_timeout() -> void:
	current_hp = min(current_hp + regeneration_amount, max_health)
	emit_signal("hp_changed", current_hp, max_health)
