extends CharacterBody2D

@onready var player = get_node("/root/Main/Player")
@onready var house = get_node("/root/Main/House")

var health = 5
var speed = 100

func _physics_process(delta):
	var direction = (house.position - global_position).normalized()
	position += direction * speed * delta
	move_and_slide()
	
	if direction.x < 0.0:
		%Sprite.flip_h = true
	else:
		%Sprite.flip_h = false
	
	## gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

func take_damage():
	health -= 1
	if health <= 0:
		queue_free()
