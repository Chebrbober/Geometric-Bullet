class_name CubeEnemy
extends Entity

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	if NodeSpawner.player != null:
		velocity = direction * speed

	move_and_slide()

func makepath() -> void:
	if NodeSpawner.player != null:
		nav_agent.target_position = NodeSpawner.player.global_position

func _on_timer_timeout() -> void:
	makepath()
