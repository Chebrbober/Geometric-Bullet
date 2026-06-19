extends CPUParticles2D

func _on_freeze_blood_timeout() -> void:
	set_process_internal(false) 
	speed_scale = 0.0 
	
	set_process(false)
	set_physics_process(false)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 30.0)
	
	tween.tween_callback(queue_free)
