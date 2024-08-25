extends State
class_name PlayerAttack

@export var character:Player
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var immobile_timing: float = 1

var init_collision_position:Vector2
var looking_direction:int
var stance
var distance_weapon 
var immobile_timer: float

func Enter():
	body_sprite.visible = true
	arm_sprite.visible = true
	immobile_timer = immobile_timing
	looking_direction = character.get_looking_direction()
	stance = character.get_stance()
	distance_weapon = character.get_distance_weapon(stance)
	
	character_collision.position.x = character.init_collision_player_position.x + looking_direction * 3
	play_animation_attack(stance)

func Exit():
	body_sprite.visible = false
	arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	var arm_frame = arm_sprite.get_frame()
	
	weapon.set_weapon_position(looking_direction, distance_weapon, 1, stance, arm_frame)
	
	var touched = character.touched
	if touched:
		Transiotioned.emit(self,"PlayerHit")
		
	if !Input.is_action_pressed("LeftClick") and immobile_timer < 0:
		Transiotioned.emit(self, "PlayerCombatMove")
	
	immobile_timer -= delta

func play_animation_attack(stance):
	var animation:String
	if stance == "high":
		animation = "HighArmAttack"
	elif stance == "medium":
		animation = "MediumArmAttack"
	elif stance == "low":
		animation = "LowArmAttack"
	
	arm_sprite.play(animation)
	body_sprite.play("attack")
