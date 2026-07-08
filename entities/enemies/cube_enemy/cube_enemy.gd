class_name CubeEnemy extends Entity

@export var spawn_rate: float = 1.0
@export var target: CharacterBody2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var attack_timer: Timer = $AttackTimer
@onready var wave_manager: WaveManager = get_parent().get_node("WaveManager")
var can_attack = true
var bodies_in_area = []
var is_dying: bool = false

signal enemy_died(enemy: CubeEnemy)

func _ready() -> void:
	super._ready()
	if is_instance_valid(wave_manager):
		enemy_died.connect(wave_manager._on_enemy_died)
	else:
		push_error("CubeEnemy: wave_manager not found! Enemy death tracking will fail.")

func _physics_process(delta: float) -> void:
	attack()
	move()
	makepath()

func die() -> void:
	if is_dying:
		return

	is_dying = true
	emit_signal("enemy_died", self)
	Global.score += 1
	Global.score_changed.emit(Global.score)
	super.die()

func attack() -> void:
	if not is_instance_valid(target):
		return

	for body in bodies_in_area.duplicate():
		if not is_instance_valid(body):
			bodies_in_area.erase(body)
			continue
		if body == target and can_attack:
			target.take_damage(damage)
			can_attack = false
			attack_timer.start()

func move() -> void:
	if not is_instance_valid(target):
		return

	var direction = (nav_agent.get_next_path_position() - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	if velocity.length() > 0.01:
		rotation = lerp_angle(rotation, velocity.angle(), 0.2)

func makepath() -> void:
	if not is_instance_valid(target):
		return

	nav_agent.target_position = target.global_position

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_attack_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	bodies_in_area.append(body)

func _on_attack_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	bodies_in_area.erase(body)
