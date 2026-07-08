extends Label

func _ready() -> void:
	Global.score_changed.connect(_on_score_changed)
	Global.wave_changed.connect(_on_wave_changed)
	text = "Score: " + str(0) + " | " + "Time Scale: " + str(Engine.time_scale)

func _on_score_changed(new_score: int) -> void:
	text = "Score: " + str(new_score) + " | " + "Time Scale: " + str(Engine.time_scale)

func _on_wave_changed(new_wave: int) -> void:
	text = "Score: " + str(Global.score) + " | " + "Time Scale: " + str(Engine.time_scale)