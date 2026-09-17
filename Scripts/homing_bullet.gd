extends Area2D

var speed := 200.0
var direction: Vector2 = Vector2.ZERO
var target = null

func _physics_process(delta):
	if target != null:
		direction = (target.global_position - global_position).normalized()
	else:
		direction = transform.x
	
	position += direction * speed * delta
	
	if speed <= 400.0:
		speed += 20.0

func _on_body_entered(body):
	queue_free()
	
	if body.has_method("take_damage"):
		body.take_damage()

func _on_area_2d_body_entered(body):
	if target == null:
		pass
	else:
		target = body
		
