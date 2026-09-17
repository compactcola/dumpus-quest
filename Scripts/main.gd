extends Node2D

func _ready():
	var spawn_left = %SpawnLeft.global_position
	var spawn_right = %SpawnRight.global_position
	Global.register_spawn_points(spawn_left, spawn_right)
	Global.register_enemy_container(%EnemyContainer)

	Global.wave_changed.connect(_on_wave_changed)
	%Label.text = "Wave: " + str(Global.wave)

func _on_wave_changed(new_wave: int):
	%Label.text = "Wave: " + str(new_wave)
