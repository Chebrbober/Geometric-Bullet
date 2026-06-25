extends PanelContainer

@export var upgrade: Upgrade
@onready var upgr_screen = get_parent().get_parent()

signal upgrade_selected(upgrade)


func _create_upgrade_item(upgrade: Upgrade, template: Node) -> void:
	var parent = template.get_parent()
	var item = template.duplicate()
	item.name = "UpgradeContainer_%s" % upgrade.name.replace(" ", "_")
	parent.add_child(item)
	item.visible = true
	item.upgrade = upgrade

	var icon = item.get_node_or_null("MarginContainer/VBoxContainer/HBoxContainer/Icon") as TextureRect
	var name_label = item.get_node_or_null("MarginContainer/VBoxContainer/HBoxContainer/NameLabel") as Label
	var rarity_label = item.get_node_or_null("MarginContainer/VBoxContainer/RarityLabel") as Label
	var desc_label = item.get_node_or_null("MarginContainer/VBoxContainer/DescriptionLabel") as Label

	if name_label:
		name_label.text = upgrade.name if upgrade.name != null else ""

	if desc_label:
		desc_label.text = upgrade.description if upgrade.description != null else ""

	if rarity_label:
		rarity_label.text = upgrade.rarity if upgrade.rarity != null else ""

	if icon and upgrade.icon:
		icon.texture = upgrade.icon


func _on_select_button_pressed() -> void:
	upgr_screen._on_upgrade_selected(upgrade)
	emit_signal("upgrade_selected")