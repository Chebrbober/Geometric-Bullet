extends Label


func _update_color() -> void:
	match text:
		"Common":
			pass
		"Uncommon":
			self.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
		"Rare":
			self.add_theme_color_override("font_color", Color(0.2, 0.6, 0.8))
		"Epic":
			self.add_theme_color_override("font_color", Color(0.6, 0.2, 0.8))
		"Legendary":
			self.add_theme_color_override("font_color", Color(1, 0.8, 0.2))


func _process(delta: float) -> void:
	pass
