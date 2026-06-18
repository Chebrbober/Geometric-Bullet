extends SubViewport

@onready var player: CharacterBody2D = %Player
@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	world_2d = get_tree().root.world_2d


func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		camera_2d.position = player.position
