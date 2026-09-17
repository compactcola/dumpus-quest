extends Node2D

func _ready():
	var spawn_left = %SpawnLeft.global_position
	var spawn_right = %SpawnRight.global_position
	Global.register_spawn_points(spawn_left, spawn_right)
	Global.register_enemy_container(%EnemyContainer)
	
	Global.show_upgrade_choices.connect(_on_show_upgrade_choices)
	Global.wave_changed.connect(_on_wave_changed)
	Global.wave_countdown_updated.connect(_on_wave_countdown_updated)
	
	%Label.text = "Wave: " + str(Global.wave)
	%Label2.text = "Beans: " + str(Global.beans)
	%TimerBar.hide()

func _on_wave_changed(new_wave):
	%Label.text = "Wave: " + str(new_wave)
	%Label2.text = "Beans: " + str(Global.beans)
	
	%TimerBar.show()
	%TimerBar.value = Global.wave_delay
	
func _on_wave_countdown_updated(time_left, max_time):
	if time_left <= 0.0:
		%TimerBar.hide()
	else:
		var percentage = (time_left / max_time) * 100.0
		%TimerBar.value = percentage
		
func _on_show_upgrade_choices(choices):
	for child in %ChoicesGrid.get_children():
		child.queue_free()
	
	%UpgradeMenu.show()
	
	for upgrade_data in choices:
		var btn = Button.new()
		
		btn.text = upgrade_data["name"] + "\n\n" + upgrade_data["desc"]
		btn.custom_minimum_size = Vector2(160,80)
		btn.add_theme_font_size_override("font_size", 12)
		
		btn.pressed.connect(func():
			%UpgradeMenu.hide() 
			%RepairHouse.hide()
			
			%TimerBar.show()   
			Global.apply_upgrade(upgrade_data["id"])
		)
		%ChoicesGrid.add_child(btn)
		
	if Global.house_health != 100.0:
		%RepairHouse.show()
		%RepairHouse.pressed.connect(func():
			if Global.beans >= Global.repair_cost:
				Global.beans -= Global.repair_cost
				Global.repair_cost *= 2
				Global.house_health = 100
				
				%RepairHouse.hide()
		)
	else:
		%RepairHouse.hide()
	
