extends Area2D

const SPEED := 400
const RANGE := 500

var damage = 1.0

var travel_dist = 0.0

func _physics_process(delta):
	position += transform.x * SPEED * delta
	travel_dist += SPEED * delta
	
	if travel_dist > RANGE:
		queue_free()


func _on_body_entered(body):
	queue_free()
	
	if body.has_method("take_damage"):
		body.take_damage(damage)
