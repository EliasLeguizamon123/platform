extends Area2D


@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.7
	if body is CharacterBody2D:
		print("es un character mio fratello")
		var player := body as CharacterBody2D
		if self.global_position.y < player.global_position.y:
			player.apply_knockback(Vector2(-200, -200))
		else:
			player.apply_knockback(Vector2(-100, -400))
			
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
