extends ProgressBar

@onready var hp_label: Label = $HPLabel

func _ready() -> void:
	var player = Global.player
	if player:
		player.connect("hp_changed", self._on_hp_changed)
		_on_hp_changed(player.current_hp, player.max_health)
	value = Global.player.current_hp
	max_value = Global.player.max_health

func _on_hp_changed(new_hp: int, max_hp: int) -> void:
	value = new_hp
	hp_label.text = str(new_hp) + " / " + str(max_hp)
