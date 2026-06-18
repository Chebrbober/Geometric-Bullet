extends Label

func _ready() -> void:
	Global.score_changed.connect(_on_score_changed)

func _on_score_changed(new_score: int) -> void:
	text = str(new_score)