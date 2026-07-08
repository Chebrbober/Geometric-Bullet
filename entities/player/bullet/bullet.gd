class_name Bullet
extends Polygon2D

@onready var area_2d: Area2D = $Area2D

var velocity = Vector2(1,0)
var speed = 250
var look_once = true
var target_position: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if look_once:
		if target_position != Vector2.ZERO:
			look_at(target_position)
		else:
			look_at(get_global_mouse_position())
		look_once = false
	global_position += velocity.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("entities") and is_instance_valid(body):
		if is_instance_valid(Global.player):
			body.take_damage(Global.player.damage)
	queue_free()
