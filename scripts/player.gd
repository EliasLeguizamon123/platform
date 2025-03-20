extends CharacterBody2D

const SPEED = 160.0
const RUN_MULTIPLIER = 1.4
const JUMP_VELOCITY = -300.0
const AIR_RESISTANCE = 0.95
const GRAVITY = 900.0
const ACCELERATION = 50.0
const DECELERATION = 5000.0
const JUMP_BOOST_MULTIPLIER = 1.2
const MAX_JUMP_CHAIN = 2
const JUMP_BUFFER_TIME = 0.13 
const GROUND_RESET_TIME = 0.12 

var jump_chain_counter: int = 0
var jump_buffer_timer: float = 0.0
var ground_time: float = 0.0
var knockback := Vector2.ZERO
var is_knockback_active := false

@onready var collision_shapen_shape = $CollisionShape2D

func _physics_process(delta: float) -> void:
	
	if is_knockback_active:
		velocity += knockback
		knockback = knockback.lerp(Vector2.ZERO, 10 * delta)  # Reducir knockback progresivamente
		
		# Si el knockback es casi cero, eliminamos la colisión
		if knockback.length() < 5:
			knockback = Vector2.ZERO
			is_knockback_active = false	
			collision_shapen_shape.queue_free()  # Remover colisión para que caiga
				
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		ground_time = 0.0
	else:
		velocity.y = 0
		jump_buffer_timer = JUMP_BUFFER_TIME
		ground_time += delta

		if ground_time >= GROUND_RESET_TIME:
			jump_chain_counter = 0
			
		if jump_chain_counter >= 3:
			jump_chain_counter = 0

	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# Manejar el salto
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() or jump_buffer_timer > 0:
			# Determinar el multiplicador según la cadena de saltos
			var jump_height = JUMP_VELOCITY * pow(JUMP_BOOST_MULTIPLIER, jump_chain_counter)
			print("Salto #", jump_chain_counter + 1, " - Altura: ", jump_height)

			velocity.y = jump_height
			jump_chain_counter = min(jump_chain_counter + 1, MAX_JUMP_CHAIN)
			jump_buffer_timer = 0
			ground_time = 0.0

	# Movimiento horizontal
	var direction := Input.get_axis("move_left", "move_right")
	var current_speed = SPEED
	
	if is_on_floor() and Input.is_action_pressed("run"):
		current_speed *= RUN_MULTIPLIER
		print("Estoy corriendo: ", current_speed)
	
	if direction != 0:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	# Resistencia en el aire
	if not is_on_floor():
		velocity.x *= AIR_RESISTANCE

	move_and_slide()
	
func apply_knockback(force: Vector2) -> void:
	print("salimos volando", force.y)
	if force.y < -300:
		return
	knockback = force
	is_knockback_active = true
