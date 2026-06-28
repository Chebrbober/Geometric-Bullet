extends Control

@export_dir var upgrades_dir
@onready var upgrade_container: PanelContainer = $HBoxContainer/UpgradeContainer
@onready var template = upgrade_container

func _ready() -> void:
	_populate_upgrades()
	template.visible = false

func _populate_upgrades() -> void:
	if upgrades_dir == null or upgrades_dir == "":
		push_error("`upgrades_dir` is not set on UpgradeScreen")
		return

	var dir = DirAccess.open(upgrades_dir)
	if dir == null:
		push_error("Failed to open upgrades_dir: %s" % upgrades_dir)
		return

	if template == null:
		push_error("UpgradeContainer template not found in scene")
		return

	template.visible = false

	var resources := []
	var upgrades := []

	dir.list_dir_begin()
	var file = dir.get_next()
	
	while file != "":
		if file.begins_with("."):
			file = dir.get_next()
			continue
		if dir.current_is_dir():
			file = dir.get_next()
			continue

		var path = upgrades_dir.rstrip("/") + "/" + file
		var res = ResourceLoader.load(path)
		if res:
			if res is Upgrade:
				resources.append(res)
			upgrades.append(res)
		else:
			print("Could not load resource: %s" % path)

		file = dir.get_next()

	dir.list_dir_end()

	var max_display = 3
	for i in resources.size():
		if i >= max_display:
			break
		var upgrade = upgrades[randi_range(0, upgrades.size() - 1)]
		upgrade_container._create_upgrade_item(upgrade, template)


func _on_upgrade_selected(upgrade: Upgrade) -> void:
	if upgrade == null:
		push_error("No upgrade was selected")
		return

	if Global.player != null:
		var stats_manager = Global.player.get_node_or_null("StatsManager")
		if stats_manager != null and stats_manager.has_method("_apply_upgrade"):
			stats_manager._apply_upgrade(upgrade)
		else:
			push_error("StatsManager not found on player")
	else:
		push_error("No player available to apply upgrade")

	get_tree().paused = false
	visible = false
