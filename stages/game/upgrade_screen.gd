extends Control

@export_dir var upgrades_dir
@onready var icon: TextureRect = %Icon 
@onready var name_label: Label = %NameLabel
@onready var rarity_label: Label = %RarityLabel
@onready var desc_label: Label = %DescriptionLabel
@onready var cost_label: Label = %CostLabel
@onready var select_btn: Button = %SelectButton
var upgrade: Upgrade

func _ready() -> void:
	_populate_upgrades()

func _populate_upgrades() -> void:
	if upgrades_dir == null or upgrades_dir == "":
		push_error("`upgrades_dir` is not set on UpgradeScreen")
		return

	var dir = DirAccess.open(upgrades_dir)
	if dir == null:
		push_error("Failed to open upgrades_dir: %s" % upgrades_dir)
		return

	var template: Node = $HBoxContainer/UpgradeContainer
	if template == null:
		push_error("UpgradeContainer template not found in scene")
		return

	template.visible = false

	var resources := []

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
			elif res is PackedScene:
				var inst = res.instantiate()
				$HBoxContainer.add_child(inst)
			elif res is Script:
				var inst_obj = res.new()
				if inst_obj is Upgrade:
					resources.append(inst_obj)
		else:
			print("Could not load resource: %s" % path)

		file = dir.get_next()

	dir.list_dir_end()

	for upgrade in resources:
		_create_upgrade_item(upgrade, template)


func _create_upgrade_item(upgrade: Upgrade, template: Node) -> void:
	var parent = template.get_parent()
	var item = template.duplicate()
	item.name = "UpgradeContainer_%s" % upgrade.name.replace(" ", "_")
	parent.add_child(item)

	if name_label:
		name_label.text = upgrade.name if upgrade.name != null else ""

	if desc_label:
		desc_label.text = upgrade.description if upgrade.description != null else ""

	if rarity_label:
		rarity_label.text = upgrade.rarity if upgrade.rarity != null else ""

	if cost_label:
		cost_label.text = str(upgrade.cost) if upgrade.cost != null else ""

	if icon and upgrade.icon:
		icon.texture = upgrade.icon
	item.visible = true

func _on_select_button_pressed() -> void:
	_on_upgrade_selected(upgrade)

func _on_upgrade_selected(upgrade: Upgrade) -> void:
	get_tree().paused = false
