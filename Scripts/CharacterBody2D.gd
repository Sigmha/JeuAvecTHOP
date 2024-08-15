extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var init_weapon_position:Vector2i
var init_collision_player_position:Vector2
var looking_direction: int = 1

@onready var player_sprite = $PlayerSprite
@onready var weapon = $Weapon 
@onready var player_collision = $PlayerCollision

func _ready():
	init_weapon_position = weapon.position
	init_collision_player_position = player_collision.position

func _physics_process(delta):
	
	move_player(delta)
	
	attack()

	move_and_slide()

func move_player(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		change_side(direction)
		looking_direction = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func change_side(direction):
	if direction == 1:
		player_sprite.flip_h = false
		weapon.rotation = 0
		player_collision.position = init_collision_player_position
		weapon.position.y = init_weapon_position.y
		
	elif direction == -1:
		player_sprite.flip_h = true
		weapon.rotation = PI
		weapon.position.y = init_weapon_position.y - 1
		player_collision.position = init_collision_player_position * Vector2(-1, 1)
		

func attack():
	var idle_length = 5
	var attack_length = 11
	
	if Input.is_action_pressed("LeftClick"):
		player_sprite.set_frame(1)
	else:
		player_sprite.set_frame(0)
	
	
	if player_sprite.get_frame() == 0:
		weapon.position.x = looking_direction * idle_length
	else:
		weapon.position.x = looking_direction * attack_length
	
