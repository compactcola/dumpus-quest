extends Area2D

var upgrade = "RAPID FIRE"

func define_upgrade(upgrade_type):
	upgrade = upgrade_type
	
## Player Enters
func _on_body_entered(body):
	
	
	if upgrade == "NONE":
		print ("upgrade failed")
		return
