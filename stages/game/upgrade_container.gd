extends PanelContainer

@export var upgrade: Upgrade
@onready var upgr_screen = get_parent().get_parent()

signal upgrade_selected(upgrade)


func _create_upgrade_item(upgrade_data: Upgrade, template: Node) -> void:
	var parent = template.get_parent()
	var item = template.duplicate()
	item.name = "UpgradeContainer_%s" % upgrade_data.name.replace(" ", "_")
	parent.add_child(item)
	item.visible = true
	item.upgrade = upgrade_data

	var icon = item.get_node_or_null("MarginContainer/VBoxContainer/HBoxContainer/Icon") as TextureRect
	var name_label = item.get_node_or_null("MarginContainer/VBoxContainer/HBoxContainer/NameLabel") as Label
	var rarity_label = item.get_node_or_null("MarginContainer/VBoxContainer/RarityLabel") as Label
	var desc_label = item.get_node_or_null("MarginContainer/VBoxContainer/DescriptionLabel") as Label

	if name_label:
		name_label.text = upgrade_data.name if upgrade_data.name != null else ""

	if desc_label:
		desc_label.text = upgrade_data.description if upgrade_data.description != null else ""

	if rarity_label:
		rarity_label.text = upgrade_data.rarity if upgrade_data.rarity != null else ""

	if icon and upgrade_data.icon:
		icon.texture = upgrade_data.icon


func _on_select_button_pressed() -> void:
	if upgrade == null:
		push_error("UpgradeContainer has no upgrade assigned")
		return

	upgr_screen._on_upgrade_selected(upgrade)
	emit_signal("upgrade_selected", upgrade)