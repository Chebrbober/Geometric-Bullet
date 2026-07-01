extends ProgressBar

@onready var hp_label: Label = $HPLabel

func _ready() -> void:
	var player = Global.player
	if player:
		player.connect("hp_changed", self._on_hp_changed)
		_on_hp_changed(player.current_hp, player.max_health)
	value = Global.player.current_hp
	max_value = Global.player.max_health

func _on_hp_changed(new_hp: float, max_hp: float) -> void:
	value = new_hp
	max_value = max_hp
	hp_label.text = str(int(new_hp)) + " / " + str(int(max_hp))
