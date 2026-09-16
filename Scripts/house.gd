extends Area2D

var health = 100.0

func _physics_process(delta):
	var overlapping_mobs = self.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:	
		health -= 10 * delta * overlapping_mobs.size()
	
	%HouseHealth.value = health
	health += 1 * delta
