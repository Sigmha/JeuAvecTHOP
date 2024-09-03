extends State
class_name EnnemyAttack

@export var attacking_margin:float = 5
@export var attack_time:float = 0.25
@export_group("Necessary")
@export var character:Ennemy
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon



var init_collision_position:Vector2
var looking_direction:int
var stance
var distance_weapon 
var attack_timer:float

func Enter():
	character.actual_state = 'attack'
	character.attacking = true
	body_sprite.visible = true
	arm_sprite.visible = true
	
	attack_timer = attack_time
	looking_direction = character.get_looking_direction()
	stance = character.actual_stance
	distance_weapon = character.get_distance_weapon(stance)
	
	character_collision.position.x = character.init_collision_ennemy_position.x + looking_direction * 3
	play_animation_attack(stance, looking_direction)

func Exit():
	body_sprite.visible = false
	arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	var arm_frame = arm_sprite.get_frame()
	
	weapon.set_weapon_position(looking_direction, distance_weapon, 1, stance, arm_frame)
	
	if attack_timer <= 0:
		if abs(character.distance_to_player) > (character.attacking_distance + attacking_margin) * character.global_scale.x or looking_direction * character.distance_to_player < 0:
			Transiotioned.emit(self,"EnnemyCombatMove")
	else:
		attack_timer -= delta
	
	#Verifie si on a été touché
	if character.touched and character.current_health <= character.player.attack_damage:
		Transiotioned.emit(self,"EnnemyDying")
	elif character.touched and character.current_health > character.player.attack_damage:
		Transiotioned.emit(self,"EnnemyHit")
	
	if character.parried:
		Transiotioned.emit(self,"EnnemyParried")

func play_animation_attack(new_stance, new_looking_direction):
	var animation:String
	var direction:String
	if new_stance == "high":
		animation = "HighArmAttack"
	elif new_stance == "medium":
		animation = "MediumArmAttack"
	elif new_stance == "low":
		animation = "LowArmAttack"
	
	if new_looking_direction == 1:
		direction = '_right'
	elif new_looking_direction == -1:
		direction = '_left'
	
	arm_sprite.play(animation + direction)
	body_sprite.play("attack" + direction)
