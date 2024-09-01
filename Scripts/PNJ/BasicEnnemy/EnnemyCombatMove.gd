extends State
class_name EnnemyCombatMove

signal changed_stance
signal changed_looking_direction

@export var change_stance_min_time:float = 1
@export var change_stance_max_time:float = 2
@export_group("Necessary")
@export var character:Ennemy
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon

var init_collision_position:Vector2
var move_speed := 200
var arm_frame:int
var looking_direction:int
var stance:String
var change_stance_timer:float

func Enter():
	character.actual_state = "combat move"
	body_sprite.visible = true
	arm_sprite.visible = true
	character.attacking = false
	character_collision.position.x = character.init_collision_ennemy_position.x
	change_stance_timer = randf_range(change_stance_min_time, change_stance_max_time)
	stance = character.new_stance()

func Exit():
	body_sprite.visible = false
	arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	var direction = character.get_looking_direction()
	var distance_weapon = character.get_distance_weapon(stance)
	
	arm_frame = arm_sprite.get_frame()
	
	set_stance_sprite(stance, direction)
	weapon.set_weapon_position(direction, distance_weapon, 0, stance, arm_frame)
	#mouvement droite gauche
	character.global_position.x += delta * direction * move_speed
	character.move_and_slide()
	
	#Verifie si on a été touché
	if character.touched and character.current_health > 1:
		Transiotioned.emit(self,"EnnemyHit")
	elif character.touched and character.current_health <= 1:
		Transiotioned.emit(self,"EnnemyDying")
	
	if change_stance_timer <= 0:
		stance = character.new_stance()
		change_stance_timer = randf_range(change_stance_min_time, change_stance_max_time)
	else:
		change_stance_timer -= delta
	
	#attaque
	if abs(character.distance_to_player) <= character.attacking_distance * character.global_scale.x and !character.player.is_rolling:
		Transiotioned.emit(self,"EnnemyAttack")
	
	if character.parried:
		Transiotioned.emit(self,"EnnemyParried")

func set_stance_sprite(new_stance, new_looking_direction):
	var arm_animation:String
	var direction:String
	
	if new_stance == "high":
		arm_animation= "HighArmIdle"
	elif new_stance == "medium":
		arm_animation = "MediumArmIdle"
	else:
		arm_animation = "LowArmIdle"
	
	if new_looking_direction == 1:
		direction = '_right'
	elif new_looking_direction == -1:
		direction = '_left'
	
	arm_sprite.set_frame(0)
	arm_sprite.play(arm_animation + direction)
	body_sprite.set_frame(0)
	body_sprite.play('idle' + direction)
