class_name BossHexagon extends CubeEnemy

@onready var animation_player: AnimationPlayer = get_node_or_null("AnimationPlayer")
@onready var laser_beam: RayCast2D = get_node_or_null("LaserBeam")

func _ready() -> void:
	if animation_player == null:
		push_error("AnimationPlayer node not found as a child of the BossHexagon.")
	animation_player.play("damage_impulse")
	await animation_player.animation_finished
	animation_player.play("damage_impulse")

func _on_laser_beam_laser_hit(collider: Entity) -> void:
	collider.take_damage(damage)
