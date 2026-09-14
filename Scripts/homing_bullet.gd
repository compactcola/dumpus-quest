extends Area2D

var speed := 200.0
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	
	if position != mouse_pos:
		direction = (mouse_pos - global_position).normalized()
	
	position += direction * speed * delta
	
	if speed <= 400.0:
		speed += 20.0
