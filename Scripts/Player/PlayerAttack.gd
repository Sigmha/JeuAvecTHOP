extends State
class_name PlayerAttack

@export var character:Player
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var immobile_timing: float = 0.5

var init_collision_position:Vector2
var immobile_timer: float

func Enter():
	immobile_timer = immobile_timing
	var looking_direction:int = character.get_looking_direction()
	var stance = character.get_stance()
	var distance_weapon = character.get_distance_weapon(stance)
	
	weapon.set_weapon_position(looking_direction, distance_weapon, 1, stance)
	
	character_collision.position.x = character.init_collision_player_position.x + looking_direction * 3
	body_sprite.set_frame(1)
	arm_sprite.set_frame(1)

func Exit():
	pass

func Update(delta):
	if !Input.is_action_pressed("LeftClick") and immobile_timer < 0:
		Transiotioned.emit(self, "PlayerCombatMove")
	
	immobile_timer -= delta

func Physics_Update(_delta):
	pass
