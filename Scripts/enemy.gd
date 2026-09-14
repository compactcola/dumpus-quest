extends CharacterBody2D

@onready var player = get_node("/root/Main/Player")

var health = 2
var speed = 200

func _physics_process(delta):
	var direction = (player.position - global_position).normalized()
	position += direction * speed * delta
	move_and_slide()
	
func take_damage():
	health -= 1
	if health <= 0:
		queue_free()
		
