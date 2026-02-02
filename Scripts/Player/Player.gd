extends CharacterBody3D
class_name Player

var speed
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8
@export var SENSITIVITY = 0.004
@export var JOYPAD_SENS = 0.05

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interactRayCast = $Head/Camera3D/InteractRayCast
@onready var gunRayCast = $Head/Camera3D/GunRayCast
@onready var gunSprite = $Head/Camera3D/GunSprite
@onready var gunFireSFX = $Head/Camera3D/GunSprite/GunFireSFX
@export var attackCooldown = 2.0

@onready var footStepSFXPlayer = $FootstepSFX
@export var footStepSounds : Array[AudioStream]
var shouldPlayFootstep = true

@onready var crosshair = $Crosshair
@export var basicCrosshair : Texture
@export var interactCrosshair : Texture

@onready var maskSprite = $HUD/Control/MaskBorder/MaskSprite
@export var neutralMask : Texture
@export var damagedMask : Texture
@export var nearDeathMask: Texture

@onready var damageScreen = $DamageFeedback
@onready var damageSFXPlayer = $DamageSFX
@onready var deathSFXPlayer = $DeathSFX
@export var damageSounds : Array[AudioStream]


@onready var pauseHUD = $PauseHUD
@onready var resumeButton = $PauseHUD/VBoxContainer/ResumeButton

@export var startDisabled : bool = false
var disabled = false
var canShoot = true

@export var shootDamage : float = 1
@export var health : float = 10

func _ready():
	gunSprite.animation_finished.connect(shoot_anim_done)
	if !startDisabled:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		gunSprite.play("idle_pistol")
	else:
		Globals.disable_player_control()
		gunSprite.play("idle_hand")
		canShoot = false

func _unhandled_input(event):
	if Globals.player_enabled == false:
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if abs(event.screen_relative.x) > 1:
			head.rotate_y(-event.screen_relative.x * SENSITIVITY)
		camera.rotate_x(-event.screen_relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _process(delta):
	if Globals.player_enabled == false:
		return
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if interactRayCast.is_colliding() and interactRayCast.get_collider().has_method("onHoverInteract"):
		crosshair.texture = interactCrosshair
	else:
		crosshair.texture = basicCrosshair
	
	if Input.is_action_just_pressed("interact"):
		if interactRayCast.is_colliding() and interactRayCast.get_collider().has_method("Interact"):
			interactRayCast.get_collider().Interact()
			
	if Input.is_action_just_pressed("pause"):
			pauseHUD.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Globals.disable_player_control()
			resumeButton.grab_focus()
			

func _physics_process(delta):
	if Globals.player_enabled == false:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Controller Rotation
	var rotate_dir = Input.get_vector("rotate_left","rotate_right","rotate_up", "rotate_down")
	
	if rotate_dir.length() > 0:
		head.rotate_y(-rotate_dir.x * JOYPAD_SENS)
		camera.rotate_x(-rotate_dir.y * JOYPAD_SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
	# Handle Jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			playFootstep()
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func playFootstep():
	if shouldPlayFootstep:
		footStepSFXPlayer.stream = footStepSounds[randi_range(0,8)]
		footStepSFXPlayer.play()
		shouldPlayFootstep = false
		await get_tree().create_timer(2.5/speed).timeout
		shouldPlayFootstep = true

func equipPistol():
	gunSprite.play("idle_pistol")

func shoot():
	if !canShoot:
		return
	canShoot = false
	gunSprite.play("shoot")
	gunFireSFX.play()
	if gunRayCast.is_colliding() and gunRayCast.get_collider().has_method("damage"):
		gunRayCast.get_collider().damage(shootDamage)

func shoot_anim_done():
	await get_tree().create_timer(attackCooldown).timeout
	canShoot = true
	gunSprite.play("idle_pistol")
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func damage(incomingDamage : float):
	health -= incomingDamage
	maskSprite.texture = damagedMask
	damageScreen.visible = true
	if health <= 0:
		deathSFXPlayer.play()
		Globals.fadeOutLoadScene("res://Levels/main_menu.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		damageSFXPlayer.stream = damageSounds[randi_range(0,2)]
		damageSFXPlayer.play()
		await get_tree().create_timer(1).timeout
		if health >= 4:
			maskSprite.texture = neutralMask
		else:
			maskSprite.texture = nearDeathMask
		damageScreen.visible = false

func _on_resume_button_pressed():
	get_tree().paused = false
	pauseHUD.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.enable_player_control()


func _on_back_to_menu_button_pressed():
	Globals.return_to_menu()


func _on_quit_game_button_pressed():
	get_tree().quit()
