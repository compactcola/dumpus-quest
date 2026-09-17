extends Area2D

func _physics_process(delta):
	var overlapping_mobs = self.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:	
		Global.house_health -= 10 * delta * overlapping_mobs.size()
	
	%HouseHealth.value = Global.house_health
	
	if Global.waves_paused == false:
		Global.house_health += 1 * delta
	
	if Global.house_health >= 99.0:
		%HouseHealth.hide()
	else:
		%HouseHealth.show()
		
	if Global.house_health <= 0.0:
		Global.game_over()
