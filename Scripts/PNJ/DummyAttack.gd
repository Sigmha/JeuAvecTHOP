extends State
class_name DummyAttack

@export var character:Dummy
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var immobile_timing: float = 0.5

var init_collision_position:Vector2
var immobile_timer: float
var player:Player

func Enter():
	immobile_timer = immobile_timing
	player = get_tree().get_first_node_in_group("Joueur")
	var looking_direction:int = get_looking_direction()
	var stance = character.get_stance()
	var distance_weapon = character.get_distance_weapon(stance)
	
	set_looking_side(looking_direction)
	set_stance_sprite(stance)
	weapon.set_weapon_position(looking_direction, distance_weapon, 1, stance)
	
	character_collision.position.x = character.init_collision_player_position.x + looking_direction * 3
	body_sprite.set_frame(1)
	arm_sprite.set_frame(1)

func Exit():
	pass

func Update(delta):
	if immobile_timer < 0:
		Transiotioned.emit(self, "DummyCombatMove")
	immobile_timer -= delta

func Physics_Update(_delta):
	pass

func get_looking_direction():
	var player_position_x = player.global_position.x
	var direction = player_position_x - character.global_position.x
	if direction > 0:
		return 1
	else:
		return -1

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
