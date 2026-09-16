extends Node2D

const BULLET := preload("res://Scenes/bullet.tscn")
const HOMING_BULLET := preload("res://Scenes/homing_bullet.tscn")

@onready var animation_player = $AnimatedSprite2D

var can_shoot = true
var can_swing = true
var shoot_delay = 2.0
var i = 0.0

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	## SHOOTING SPELLS
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		i = shoot_delay
		can_shoot = false
	
	## Delay
	if can_shoot == false and i > 0.0:
		i -= 10 * delta
	elif can_shoot == false and i <= 0.0:
		can_shoot = true
		i = shoot_delay
		
	
	## SWINGING STAFF
	if Input.is_action_just_pressed("swing") and can_swing:
		pass
		##animation_player.play("swing")
	else:
		pass
		##animation_player.queue("idle")


func shoot():
	var new_bullet = BULLET.instantiate()
	
	get_tree().root.add_child(new_bullet)
	
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
