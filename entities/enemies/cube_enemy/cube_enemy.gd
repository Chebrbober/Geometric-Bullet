class_name CubeEnemy
extends Entity

func _physics_process(delta: float) -> void:
    if NodeSpawner.player != null:
        var direction = global_position.direction_to(NodeSpawner.player.global_position)
        velocity = direction * speed
    
    move_and_collide(velocity * delta)
