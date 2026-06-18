class_name CubeEnemy
extends Entity

@export var spawn_rate: float = 1.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_timer: Timer = $AttackTimer
@onready var wave_manager: WaveManager = get_parent().get_node("WaveManager")
var can_attack = true
var bodies_in_area = []

func _physics_process(delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	if Global.player != null:
		velocity = direction * speed

	move_and_slide()

func _process(delta: float) -> void:
	for body in bodies_in_area:
		if body == Global.player and can_attack:
			Global.player.take_damage(damage)
			can_attack = false
			attack_timer.start()

func die() -> void:
	super.die()
	wave_manager.enemies_to_kill -= 1

func makepath() -> void:
	if Global.player != null:
		nav_agent.target_position = Global.player.global_position

func _on_timer_timeout() -> void:
	makepath()

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_attack_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	bodies_in_area.append(body)

func _on_attack_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	bodies_in_area.erase(body)
