class_name CubeEnemy
extends Entity

func _physics_process(delta: float) -> void:
	if NodeSpawner.player != null:
		velocity = global_position.direction_to(NodeSpawner.player.global_position)
	global_position += velocity * speed * delta
	move_and_slide()
