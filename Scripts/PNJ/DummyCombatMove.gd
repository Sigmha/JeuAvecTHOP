extends State
class_name DummyCombatMove

@export var character:Dummy
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var action_timing: float = 1

var init_collision_position:Vector2
var move_speed := 500
var action_timer:float
var has_attacked: bool
var player:Player

func Enter():
	player = get_tree().get_first_node_in_group("Joueur")
	action_timer = action_timing
	character_collision.position.x = character.init_collision_player_position.x
	
	var looking_direction:int = get_looking_direction()
	var stance = character.get_stance()
	var distance_weapon = character.get_distance_weapon(stance)
	var attacking:bool = rand_attack()
	
	set_looking_side(looking_direction)
	set_stance_action(stance, attacking)
	weapon.set_dummy_weapon_position(looking_direction, distance_weapon, attacking, stance)

func Exit():
	pass

func Update(delta):
	if action_timer <= 0:
		Transiotioned.emit(self,"DummyCombatMove")
	action_timer -= delta

func Physics_Update(_delta):
	pass

func set_looking_side(looking_direction):
	if looking_direction == 1:
		body_sprite.flip_h = false
		arm_sprite.flip_h = false
	
	elif looking_direction == -1:
		body_sprite.flip_h = true
		arm_sprite.flip_h = true

func set_stance_action(stance, attacking):
	if stance == "high":
		arm_sprite.animation = "HighArm"
	elif stance == "medium":
		arm_sprite.animation = "MediumArm"
	else:
		arm_sprite.animation = "LowArm"
	
	if attacking:
		body_sprite.set_frame(1)
		arm_sprite.set_frame(1)
	else:
		body_sprite.set_frame(0)
		arm_sprite.set_frame(0)

func rand_attack():
	if randi_range(0, 1) and !has_attacked:
		has_attacked = true
		return true
	else:
		has_attacked = false
		return false

func get_looking_direction():
	var player_position_x = player.global_position.x
	var direction = player_position_x - character.global_position.x
	if direction > 0:
		return 1
	else:
		return -1
