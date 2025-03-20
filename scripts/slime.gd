extends Node2D

const SPEED = 60

var direction = -1

@onready var ray_cast_right = $RaycastRight
@onready var ray_cast_left = $RaycastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.flip_h = true

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
		
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
