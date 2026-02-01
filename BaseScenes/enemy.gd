extends CharacterBody3D

@onready var enemy_sprite = $EnemySprite
@onready var cooldownTimer = $AttackCooldown

@export var move_speed = 3
@export var health = 5
@export var attack_range = 2.0
@export var attack_damage = 1.0
@export var attack_cooldown = 0.5
@export var detection_range = 10

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var DeathSFX = $DeathSound
@onready var DamageSFX = $DamageSound
var dead = false
var canAttack = true

func _ready():
	cooldownTimer.wait_time = attack_cooldown

func _physics_process(delta):
	if dead || !canAttack:
		return
	if player == null:
		return
	if Globals.player_enabled == false:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0.0
	if dir.length() > detection_range:
		enemy_sprite.play("idle")
		return
	
	
	dir = dir.normalized()
	velocity = dir * move_speed
	enemy_sprite.play("walking")
	move_and_slide()
	if canAttack:
		attempt_to_kill_player()

func attempt_to_kill_player():
	if Globals.player_enabled == false:
		return
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	print("deal damage")
	enemy_sprite.play("attack")
	player.damage(1)
	canAttack = false
	cooldownTimer.start()
	await cooldownTimer.timeout
	canAttack = true

func damage(incoming_damage:float):
	health -= incoming_damage
	if health <= 0:
		dead = true
		DeathSFX.play()
		enemy_sprite.play("death")
		$CollisionShape3D.disabled = true
	else:
		DamageSFX.play()
		enemy_sprite.modulate = Color.INDIAN_RED
		await get_tree().create_timer(0.5).timeout
		enemy_sprite.modulate = Color.WHITE
