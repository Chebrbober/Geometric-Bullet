extends Node

@onready var player: Entity = get_parent() as Entity


func _apply_upgrade(upgrade: Upgrade) -> void:
	if upgrade == null:
		return

	if player == null:
		player = get_parent() as Entity

	if player == null:
		push_error("StatsManager has no player parent")
		return

	match upgrade.stat_type:
		"health":
			player.max_health *= upgrade.value
		"speed":
			player.speed *= upgrade.value
		"damage":
			player.damage *= upgrade.value
		"reload_speed":
			player.reload_speed_timer.wait_time /= upgrade.value
		"regeneration_interval":
			player.regeneration_timer.wait_time /= upgrade.value
		"regeneration_amount":
			player.regeneration_amount *= upgrade.value

	player.hp_changed.emit(player.current_hp, player.max_health)
