extends Node2D

@onready var spawn_left = %SpawnLeft.global_position
@onready var spawn_right = %SpawnRight.global_position

const ENEMY = preload("res://Scenes/enemy.tscn")

var wave = 0

func _ready():
	spawn_wave()
	
func spawn_wave():
	spawn_enemy(spawn_left)
	print("wave started")

func spawn_enemy(enemy_position):
	var new_enemy = ENEMY.instantiate()
	
	new_enemy.is_flying = false
	
	self.add_child(new_enemy)
	new_enemy.global_position = enemy_position
