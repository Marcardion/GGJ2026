extends CharacterBody3D

@onready var enemy_sprite = $EnemySprite

@export var move_speed = 2.0
@export var attack_range = 2.0

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
var dead = false

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	if Globals.player_enabled ==false:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	move_and_slide()
	attempt_to_kill_player()

func attempt_to_kill_player():
	if Globals.player_enabled == false:
		return
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	player.damage(1)
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		pass
	

func damage(incoming_damage:float):
	dead = true
	$DeathSound.play()
	enemy_sprite.play("death")
	$CollisionShape3D.disabled = true
