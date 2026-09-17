extends Node

signal wave_changed(new_wave:int)

var spawn_left: Vector2
var spawn_right: Vector2

const ENEMY = preload("res://Scenes/enemy.tscn")
var enemies = []
var enemy_parent_node : Node2D = null

var wave = 0
var wave_spawning = false

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
		wave_spawning = true
		spawn_wave()
	
func spawn_wave():
	print("Spawning wave...")
	wave += 1
	wave_changed.emit(wave)
	
	for i in range(wave):
		spawn_enemy(spawn_left)
		spawn_enemy(spawn_right)
	
	wave_spawning = false

func spawn_enemy(enemy_position):
	print("Enemy spawn started...")
	
	if enemy_parent_node != null:
		var new_enemy = ENEMY.instantiate()
		enemies.append(new_enemy)
		enemy_parent_node.add_child(new_enemy)
		new_enemy.global_position = enemy_position
	else:
		breakpoint
	
