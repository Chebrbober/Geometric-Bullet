class_name CubeEnemy extends Entity

@export var spawn_rate: float = 1.0
@export var target: CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_timer: Timer = $AttackTimer
@onready var wave_manager: WaveManager = get_parent().get_node("WaveManager")
var can_attack = true
var bodies_in_area = []

func _physics_process(delta: float) -> void:
	attack()
	move()
	makepath()

func die() -> void:
	super.die()
	wave_manager.enemies_to_kill -= 1

func attack() -> void:
	for body in bodies_in_area:
		if body == target and can_attack:
			target.take_damage(damage)
			can_attack = false
			attack_timer.start()

func move() -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	if target != null:
		velocity = direction * speed
		polygon2d.rotation = direction.angle()
	move_and_slide()

func makepath() -> void:
	nav_agent.target_position = target.global_position

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_attack_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	bodies_in_area.append(body)

func _on_attack_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	bodies_in_area.erase(body)
