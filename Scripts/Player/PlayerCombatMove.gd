extends State
class_name PlayerCombatMove

signal changed_stance
signal changed_looking_direction

const EPEE_CURSEUR_BD = preload("res://Assets/curseur/epeeCurseurBD.png")
const EPEE_CURSEUR_BG = preload("res://Assets/curseur/epeeCurseurBG.png")
const EPEE_CURSEUR_HD = preload("res://Assets/curseur/epeeCurseurHD.png")
const EPEE_CURSEUR_HG = preload("res://Assets/curseur/epeeCurseurHG.png")
const EPEE_CURSEUR_MD = preload("res://Assets/curseur/epeeCurseurMD.png")
const EPEE_CURSEUR_MG = preload("res://Assets/curseur/epeeCurseurMG.png")

@export_group("Necessary")
@export var character:Player
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon

var init_collision_position:Vector2
var move_speed := 500
var arm_frame:int
var looking_direction:int
var stance:String
var distance_weapon

func Enter():
	character.actual_state = "combat move"
	body_sprite.visible = true
	arm_sprite.visible = true
	character.attacking = false
	character_collision.position.x = character.init_collision_player_position.x
	changed_looking_direction.emit()
	changed_stance.emit()
	distance_weapon = character.get_distance_weapon(stance)
	weapon.set_weapon_position(looking_direction, distance_weapon, 0, stance, arm_frame)

func Exit():
	body_sprite.visible = false
	arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	if stance != character.get_stance():
		changed_stance.emit()
	if looking_direction != character.get_looking_direction():
		changed_looking_direction.emit()
		
	distance_weapon = character.get_distance_weapon(stance)
	arm_frame = arm_sprite.get_frame()
	
	weapon.set_weapon_position(looking_direction, distance_weapon, 0, stance, arm_frame)
	
	#Verifie si on a été touché
	if character.touched:
		Transiotioned.emit(self,"PlayerHit")
	
	#permet de se mettre en mode city
	if !character.is_in_fight:
		Transiotioned.emit(self,"PlayerCityMove")
	
	#mouvement droite gauche
	var direction:int = 0
	if Input.is_action_pressed("MoveLeft"):
		direction = -1
	elif  Input.is_action_pressed("MoveRight"):
		direction = 1
	character.position.x += delta * direction * move_speed
	character.move_and_slide()
	
	#attaque
	if Input.is_action_just_pressed("LeftClick"):
		Transiotioned.emit(self,"PlayerAttack")
	
	#roulade
	if Input.is_action_just_pressed("ui_accept") and character.rooling_cooldown_timer <= 0:
		Transiotioned.emit(self,"PlayerRolling")
	
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

func set_mouse_cursor():
	if looking_direction == 1:
		if stance == "high":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_HD)
		if stance == "medium":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_MD)
		if stance == "low":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_BD)
	elif looking_direction == -1:
		if stance == "high":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_HG)
		if stance == "medium":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_MG)
		if stance == "low":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_BG)

func _on_changed_stance():
	stance = character.get_stance()
	set_stance_sprite(stance ,character.get_looking_direction())
	set_mouse_cursor()


func _on_changed_looking_direction():
	stance = character.get_stance()
	looking_direction = character.get_looking_direction()
	set_stance_sprite(stance ,looking_direction)
	set_mouse_cursor()
