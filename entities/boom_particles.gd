extends CPUParticles2D

@onready var sparks: CPUParticles2D = $Sparks
@onready var fire: CPUParticles2D = $Fire

func _ready() -> void:
	emitting = true
	if is_instance_valid(sparks):
		sparks.global_position = global_position
		sparks.emitting = true
	if is_instance_valid(fire):
		fire.global_position = global_position
		fire.emitting = true