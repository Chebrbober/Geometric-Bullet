class_name Player
extends Entity

@export var bullet: PackedScene
@onready var reload_speed_timer: Timer = $ReloadSpeedTimer

var can_shoot: bool = true

func _ready() -> void:
	NodeSpawner.player = self

func _exit_tree() -> void:
	NodeSpawner.player = null

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

	if Input.is_action_pressed("shoot") and NodeSpawner.node_creation_parent != null and can_shoot:
		NodeSpawner.instance_node(bullet, global_position, NodeSpawner.node_creation_parent)
		reload_speed_timer.start()
		can_shoot = false
	
func _on_reload_speed_timeout() -> void:
	can_shoot = true