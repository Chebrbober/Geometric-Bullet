extends Node

var player: CharacterBody2D = get_parent() as Entity


func _apply_upgrade(upgrade: Upgrade) -> void:
	match upgrade.stat_type:
		"health":
			player.max_health *= upgrade.value
		"speed":
			player.speed *= upgrade.value
		"damage":
			player.damage *= upgrade.value
