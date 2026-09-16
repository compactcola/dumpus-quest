extends CharacterBody2D

@onready var anim_player = %DumpusBody

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const UP_DIRECTION := Vector2.UP

var stamina = 100.0
var regen_stamina = false
var sprint_speed = 1.0

func _physics_process(delta):
	
	## FLIPPING CHARACTER
	var mouse_pos = get_global_mouse_position()
	var mouse_angle = rad_to_deg(to_local(mouse_pos).angle())
	
	if mouse_angle > 90 or mouse_angle < -90:
		%DumpusBody.flip_h = true
		%Staff.scale.y = -1
		anim_player.play("turn")
		anim_player.play("idle")
	else:
		%DumpusBody.flip_h = false
		%Staff.scale.y = 1
		anim_player.play("idle")
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# JUMPING
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# MOVEMENT
	%StaminaBar.value = stamina
	
	if Input.is_action_pressed("sprint") and stamina > 0:
		sprint_speed = 1.5
		stamina -= 75.0 * delta
	else:
		sprint_speed = 1.0
		stamina += 2.0 * delta
	
	if stamina < 100.0:
		%StaminaBar.show()
	else:
		%StaminaBar.hide()
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * sprint_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
	var is_falling = velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0
	var is_idle = is_on_floor() and is_zero_approx(velocity.x)
	var is_running = is_on_floor() and not is_zero_approx(velocity.x)

	
