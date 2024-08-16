extends CharacterBody2D
class_name Dummy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var win_size: Vector2i

var init_collision_player_position:Vector2
var rand_stance: int
var attacking: bool = false
var actual_stance: String

@onready var body_sprite = $DummySpriteComposition/BodySprite
@onready var high_arm_sprite = $DummySpriteComposition/HighArmSprite
@onready var medium_arm_sprite = $DummySpriteComposition/MediumArmSprite
@onready var low_arm_sprite = $DummySpriteComposition/LowArmSprite
@onready var weapon = $weapon
@onready var collision = $DummyCollision
@onready var change_stance_timer = $ChangeStanceTimer
@onready var touched_label:Label = $TouchedLabel
@onready var touched_timer:Timer = $TouchedLabel/TouchedTimer

func _ready():
	#win_size = get_viewport_rect().size
	#init_collision_player_position = collision.position
	actual_stance = "medium"
	set_stance_sprite(actual_stance)
	weapon.set_weapon_position(1, get_distance_weapon(actual_stance), attacking, actual_stance)
	pass

func _physics_process(delta):
	#var looking_direction = get_looking_direction()
	#var distance_weapon = get_distance_weapon(actual_stance)
	#var stance_sprite = get_stance_sprite(actual_stance)
	#
	#set_stance_sprite(actual_stance)
	##set_looking_side(looking_direction)
	#weapon.set_weapon_position(looking_direction, distance_weapon, attacking, actual_stance)
	#attack(stance_sprite)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

#A CHANGER SI ON CHANGE LE SPRITE, reprendre les mesures pour la position de
#l'épée en idle et en attaque pour les 3 stances
#Retourne la position de l'épée selon la stance et si on attaque ou non
func get_distance_weapon(stance):
	var distance_weapon_idle: Vector2
	var distance_weapon_attack: Vector2
	if stance == "high":
		distance_weapon_idle = Vector2i(3, -23) 
		distance_weapon_attack = Vector2i(13, -23)
	elif stance == "medium":
		distance_weapon_idle = Vector2i(3, -18)
		distance_weapon_attack = Vector2i(13, -15)
	else:
		distance_weapon_idle = Vector2i(0, -11)
		distance_weapon_attack = Vector2i(9, -10)
	return [distance_weapon_idle, distance_weapon_attack]

#Flip le joueur en fonction d'où on regarde. Ne flip que le joueur mais pas 
#l'arme. Flip les sprite et la colision

#func set_looking_side(looking_direction):
	#if !attacking:
		#var stance = get_stance()
		#var stance_sprite = get_stance_sprite(stance)
		#if looking_direction == 1:
			#player_body_sprite.flip_h = false
			#stance_sprite.flip_h = false
			#player_collision.position = init_collision_player_position
		#
		#elif looking_direction == -1:
			#player_body_sprite.flip_h = true
			#stance_sprite.flip_h = true
			#player_collision.position = init_collision_player_position * Vector2(-1, 1)

#Defini le sprite si on attaque ou non et le booléen attacking

func attack(stance_sprite):
	if attacking:
		body_sprite.set_frame(1)
		stance_sprite.set_frame(1)
	else:
		body_sprite.set_frame(0)
		stance_sprite.set_frame(0)

#Renvoie la stance actuelle
func get_stance():
	var stance_tab = ["high", "medium", "low"]
	var rand_stance = randi_range(0, 2)
	return stance_tab[rand_stance]

#renvoie le sprite associé à la stance
func get_stance_sprite(stance):
	var stance_sprite
	if stance == "high":
		stance_sprite = high_arm_sprite
	elif stance == "medium":
		stance_sprite = medium_arm_sprite
	else:
		stance_sprite = low_arm_sprite
	return stance_sprite

#Affiche le bon sprite selon la stance et renvoie ce sprite
func set_stance_sprite(stance):
	if stance == "high":
		high_arm_sprite.visible = true
		medium_arm_sprite.visible = false
		low_arm_sprite.visible = false
	elif stance == "medium":
		high_arm_sprite.visible = false
		medium_arm_sprite.visible = true
		low_arm_sprite.visible = false
	else:
		high_arm_sprite.visible = false
		medium_arm_sprite.visible = false
		low_arm_sprite.visible = true

#Retourne là où on regarde se si la souris est à droite où à gauche du perso

func get_looking_direction():
	#var mouse_position_x = get_viewport().get_mouse_position().x
	#var direction = mouse_position_x - self.position.x
	#if direction > 0:
		#return 1
	#else:
	return 1

func _on_change_stance_timer_timeout():
	change_stance_timer.start()
	set_global_stance()

func set_global_stance():
	var stance = get_stance()
	rand_attacking()
	var stance_sprite = get_stance_sprite(stance)
	
	set_stance_sprite(stance)
	weapon.set_dummy_weapon_position(1, get_distance_weapon(stance), attacking, stance)
	attack(stance_sprite)

func rand_attacking():
	var rand_attack = randi_range(0, 1)
	if rand_attack and !attacking:
		attacking = true
	else:
		attacking = false


func _on_weapon_player_touched():
	touched_label.text = "player touched"
	touched_timer.start()

func _on_weapon_weapon_touched():
	touched_label.text = "weapon touched"
	touched_timer.start()
