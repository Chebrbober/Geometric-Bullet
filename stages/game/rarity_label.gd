extends Label


func _ready() -> void:
	match text:
		"Common":
			self.add_theme_color_override("font_color", Color(1, 1, 1))
		"Uncommon":
			self.add_theme_color_override("font_color", Color(0.2, 1, 0.2))
		"Rare":
			self.add_theme_color_override("font_color", Color(0.2, 0.6, 1))
		"Epic":
			self.add_theme_color_override("font_color", Color(0.6, 0.2, 1))
		"Legendary":
			self.add_theme_color_override("font_color", Color(1, 0.8, 0.2))


func _process(delta: float) -> void:
	pass
