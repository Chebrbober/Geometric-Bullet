@tool
extends RayCast2D

@export var cast_speed: float = 7000.0
@export var max_length: float = 7000.0

@export var is_casting: bool = false: 
	set(value): 
		is_casting = value
		set_physics_process(is_casting)

@export var color: Color = Color.WHITE: 
	set(value): 
		if line_2d == null:
			return
		set_color(value)

@export var growth_time: float = 0.1
@onready var line_2d: Line2D = get_node_or_null("Line2D")
@onready var line_width: float = 10.0 
@onready var casting_particles: GPUParticles2D = get_node_or_null("CastingParticles")
@onready var beam_particles: GPUParticles2D = get_node_or_null("BeamParticles")
@onready var tween: Tween

signal laser_hit(collider: Entity)

func _ready() -> void:
	set_physics_process(false)
	if line_2d == null:
		push_error("Line2D node not found as a child of the laser beam.")
		return
	else:
		var points := line_2d.points
		points[1] = Vector2.ZERO
		line_2d.points = points
	set_color(color)
	set_is_casting(is_casting)

func _physics_process(delta: float) -> void:
	update_laser_position(delta)
	update_beam_particles_position()

func set_is_casting(new_value: bool) -> void:
	if !is_node_ready():
		return
	if is_casting == new_value:
		return
	is_casting = new_value
	set_physics_process(is_casting)

	if is_casting == false:
		target_position.x = Vector2.ZERO.x
	else:
		pass

func set_color(new_color: Color) -> void:
	line_2d.default_color = new_color
	if casting_particles != null and is_instance_valid(casting_particles):
		casting_particles.modulate = new_color
	#if collision_particles != null and is_instance_valid(collision_particles):
		#collision_particles.modulate = new_color
	if beam_particles != null and is_instance_valid(beam_particles):
		beam_particles.modulate = new_color

func update_laser_position(delta: float) -> void:
	var cast_point: Vector2 = target_position
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		laser_hit.emit(get_collider())
	var points := line_2d.points
	points[1] = cast_point
	line_2d.points = points 

func update_beam_particles_position() -> void:
	var laser_start_position := line_2d.points[0]
	var laser_end_position := target_position
	beam_particles.position = laser_start_position + (laser_end_position - laser_start_position) * 0.5
