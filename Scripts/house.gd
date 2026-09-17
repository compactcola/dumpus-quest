extends Area2D

var health = 100.0

func _physics_process(delta):
	var overlapping_mobs = self.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:	
		health -= 10 * delta * overlapping_mobs.size()
	
	%HouseHealth.value = health
	
	if Global.waves_paused == false:
		health += 1 * delta
	
	if health >= 99.0:
		%HouseHealth.hide()
	else:
		%HouseHealth.show()
		
	if health <= 0.0:
		Global.game_over()
