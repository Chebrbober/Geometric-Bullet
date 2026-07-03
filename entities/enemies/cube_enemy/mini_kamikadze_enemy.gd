class_name MiniKamikadzeEnemy extends CubeEnemy

@export var boom_particles: PackedScene
@onready var boom_timer: Timer = $BoomTimer
@onready var beep_light: Polygon2D = %BeepLight
var is_player_in_area: bool = false
var entities_in_area: Array[Entity] = []
var freeze: bool = false
var is_dying: bool = false


func _physics_process(delta: float) -> void:
	if not freeze:
		super.move()
		super.makepath()

func attack() -> void:
	return

func start_beeping() -> void:
	if not is_player_in_area:
		return

	for i in range(3):
		if boom_timer.wait_time <= 0:
			die()
			return

		boom_timer.start()
		await boom_timer.timeout
		if not is_player_in_area:
			return
		beep()

		var new_time := boom_timer.wait_time - 0.2
		if new_time <= 0:
			die()
			return
		boom_timer.wait_time = new_time


func beep() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(beep_light, "color", Color.WHITE, 0.05)
	stun_timer.start()

func die():
	if is_dying:
		return
	is_dying = true

	if Global.node_creation_parent != null:
		Global.instance_node(boom_particles, global_position, Global.node_creation_parent)
	call_deferred("_damage_nearby_entities")
	super.die()

func _damage_nearby_entities() -> void:
	for body in entities_in_area.duplicate():
		if is_instance_valid(body) and body is Entity and body != self:
			body.take_damage(damage)

func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		is_player_in_area = false
		freeze = false
	if body is Entity:
		entities_in_area.erase(body)

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		is_player_in_area = true
		start_beeping()
		freeze = true
	if body is Entity and body != self:
		entities_in_area.append(body)