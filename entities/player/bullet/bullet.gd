extends Polygon2D

@onready var area_2d: Area2D = $Area2D


var velocity = Vector2(1,0)
var speed = 250

var look_once = true

func _process(delta: float) -> void:
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	global_position += velocity.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(1)
	queue_free()
