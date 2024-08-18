extends State
class_name PlayerCombatMove

@export var character:Player
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon

var init_collision_position:Vector2
var move_speed := 500


func Enter():
	character_collision.position.x = character.init_collision_player_position.x
	body_sprite.set_frame(0)
	arm_sprite.set_frame(0)

func Exit():
	pass

func Update(_delta):
	pass

func Physics_Update(delta):
	var looking_direction:int = character.get_looking_direction()
	var stance = character.get_stance()
	var distance_weapon = character.get_distance_weapon(stance)
	
	set_looking_side(looking_direction)
	set_stance_sprite(stance)
	weapon.set_weapon_position(looking_direction, distance_weapon, 0, stance)
	
	if Input.is_action_just_pressed("LeftClick"):
		Transiotioned.emit(self,"PlayerAttack")
	
	var direction:int = 0
	if Input.is_action_pressed("MoveLeft"):
		direction = -1
	elif  Input.is_action_pressed("MoveRight"):
		direction = 1
	character.position.x += delta * direction * move_speed
	
func set_looking_side(looking_direction):
	if looking_direction == 1:
		body_sprite.flip_h = false
		arm_sprite.flip_h = false
	
	elif looking_direction == -1:
		body_sprite.flip_h = true
		arm_sprite.flip_h = true

func set_stance_sprite(stance):
	if stance == "high":
		arm_sprite.animation = "HighArm"
	elif stance == "medium":
		arm_sprite.animation = "MediumArm"
	else:
		arm_sprite.animation = "LowArm"
