extends State
class_name EnnemyCombatMove

signal changed_stance
signal changed_looking_direction

@export var character:Ennemy
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon

var init_collision_position:Vector2
var move_speed := 300
var arm_frame:int
var looking_direction:int
var stance:String
var action:String
var distance_to_player:float

func Enter():
	character.actual_state = "combat move"
	body_sprite.visible = true
	arm_sprite.visible = true
	character.attacking = false
	character_collision.position.x = character.init_collision_player_position.x
	_on_changed_looking_direction()
	_on_changed_stance()

func Exit():
	body_sprite.visible = false
	arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	var direction = character.get_looking_direction()
		
	var distance_weapon = character.get_distance_weapon(stance)
	arm_frame = arm_sprite.get_frame()
	
	weapon.set_weapon_position(direction, distance_weapon, 0, stance, arm_frame)
	
	#Verifie si on a été touché
	var touched = character.touched
	if touched:
		Transiotioned.emit(self,"PlayerHit")
	
	#permet de se mettre en mode city
	if !character.is_in_fight:
		Transiotioned.emit(self,"PlayerCityMove")
	
	#mouvement droite gauche
	character.global_position.x += delta * direction * move_speed
	character.move_and_slide()
	
	#attaque
	if character.attacking:
		Transiotioned.emit(self,"PlayerAttack")
	
	var parried = character.parried
	if parried:
		Transiotioned.emit(self,"PlayerParried")

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

func _on_changed_stance():
	stance = character.new_stance()
	set_stance_sprite(stance ,character.get_looking_direction())


func _on_changed_looking_direction():
	stance = character.get_stance()
	looking_direction = character.get_looking_direction()
	set_stance_sprite(stance ,looking_direction)
