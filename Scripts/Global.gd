extends Node

signal wave_changed(new_wave)
signal wave_countdown_updated(time_left, max_time)

signal show_upgrade_choices(choices)
signal upgrade_selected()
signal upgrade(upgrade_id)

var spawn_left: Vector2
var spawn_right: Vector2

const ENEMY = preload("res://Scenes/enemy.tscn")
var enemies = []
var enemy_parent_node : Node2D = null

var wave = 0
var wave_spawning = false
var waves_paused = true

var beans = 0
var house_health = 100.0
var repair_cost = 10

@export var spawn_delay = 0.5 
@export var wave_delay = 3.0

var upgrade_pool: Array[Dictionary] = [
	{"id": "move speed", "name": "NEW SHOES", "desc": "Movement Speed +20%"},
	{"id": "cast speed", "name": "SPRAY N' PRAY", "desc": "Casting Speed +25%"},
	{"id": "spell damage", "name": "HIGH-CALIBER MAGIC", "desc": "Spell Damage +30%"},
	{"id": "jump height", "name": "BOUNCY", "desc": "Jump Height +10%"},
	{"id": "stamina", "name": "CARBOLOAD", "desc": "Stamina +20%"}
]

func apply_upgrade(upgrade_id):
	print("selecting upgrade...")
	print(upgrade_id)
	
	## add later to actually apply upgrade
	upgrade.emit(upgrade_id)

	upgrade_selected.emit()

func register_spawn_points(left, right):
	spawn_left = left
	spawn_right = right
	print("Spawn points registered!")
	
func register_enemy_container(container : Node2D):
	if is_instance_valid(container):
		enemy_parent_node = container
		print("Enemy container landed")
	else:
		push_warning("No enemy container found!")

func _process(delta):
	if enemy_parent_node == null:
		return
	
	## checks the array and clears killed enemies
	enemies = enemies.filter(func(enemy): 
		return is_instance_valid(enemy))
	
	if enemies.is_empty() and not wave_spawning:
		spawn_wave()
	
func spawn_wave():
	print("Spawning wave...")
	wave_spawning = true
	wave += 1
	wave_changed.emit(wave)
	
	## upgrades!
	var avaliable_pool = upgrade_pool.duplicate()
	avaliable_pool.shuffle()
	var chosen_three = avaliable_pool.slice(0,3)
	
	show_upgrade_choices.emit(chosen_three)
	waves_paused = true
	await upgrade_selected
	
	## time between waves behavior
	var time_left = wave_delay
	while time_left > 0:
		wave_countdown_updated.emit(time_left, wave_delay)
		await get_tree().process_frame
		time_left -= get_process_delta_time()
		waves_paused = false
	wave_countdown_updated.emit(0.0, wave_delay)
	
	for i in range(wave):
		spawn_enemy(spawn_left)
		await get_tree().create_timer(spawn_delay * randf_range(0.25,1.75)).timeout 
		
		spawn_enemy(spawn_right)
		await get_tree().create_timer(spawn_delay* randf_range(0.25,1.75)).timeout 
	
	wave_spawning = false

func spawn_enemy(enemy_position):
	print("Enemy spawn started...")
	
	if enemy_parent_node != null:
		var new_enemy = ENEMY.instantiate()
		
		if randf() > 0.66:
			new_enemy.is_flying = true
		
		enemies.append(new_enemy)
		enemy_parent_node.add_child(new_enemy)
		
		if new_enemy.is_flying == true:
			new_enemy.global_position.x = enemy_position.x
			new_enemy.global_position.y = enemy_position.y - randf_range(4, 128)
		else:
			new_enemy.global_position = enemy_position
	
func game_over():
	%GameOver.show() ## explodes for some reason?
	
	get_tree().paused = true
	get_tree().create_timer(3.0).timeout
	
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
