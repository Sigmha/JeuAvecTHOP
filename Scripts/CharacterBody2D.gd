extends CharacterBody2D

const SPEED = 500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var win_size: Vector2i

var init_collision_player_position:Vector2

var attacking: bool

@onready var player_body_sprite = $PlayerSpriteComposition/BodySprite
@onready var player_high_arm_sprite = $PlayerSpriteComposition/HighArmSprite
@onready var player_medium_arm_sprite = $PlayerSpriteComposition/MediumArmSprite
@onready var player_low_arm_sprite = $PlayerSpriteComposition/LowArmSprite
@onready var weapon = $Weapon 
@onready var player_collision = $PlayerCollision

func _ready():
	win_size = get_viewport_rect().size
	init_collision_player_position = player_collision.position

func _physics_process(delta):
	var looking_direction = get_looking_direction()
	var stance = get_stance()
	var distance_weapon = get_distance_weapon(stance)
	var stance_sprite = get_stance_sprite(stance)
	
	
	set_stance_sprite(stance)
	move_player(delta)
	set_looking_side(looking_direction)
		
	weapon.set_weapon_position(looking_direction, distance_weapon, attacking, stance)
	attack(stance_sprite)

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

#Permet de mouvoir le joueur à droite et à gauche avec les flèche et
#d'appliquer la gravité
func move_player(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and !attacking:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

#Flip le joueur en fonction d'où on regarde. Ne flip que le joueur mais pas 
#l'arme. Flip les sprite et la colision
func set_looking_side(looking_direction):
	if !attacking:
		var stance = get_stance()
		var stance_sprite = get_stance_sprite(stance)
		if looking_direction == 1:
			player_body_sprite.flip_h = false
			stance_sprite.flip_h = false
			player_collision.position = init_collision_player_position
		
		elif looking_direction == -1:
			player_body_sprite.flip_h = true
			stance_sprite.flip_h = true
			player_collision.position = init_collision_player_position * Vector2(-1, 1)

#Defini le sprite si on attaque ou non et le booléen attacking
func attack(stance_sprite):
	if Input.is_action_pressed("LeftClick"):
		player_body_sprite.set_frame(1)
		stance_sprite.set_frame(1)
	else:
		player_body_sprite.set_frame(0)
		stance_sprite.set_frame(0)
	
	if player_body_sprite.get_frame() == 0:
		attacking = false
	else:
		attacking = true

#Renvoie la stance actuelle
func get_stance():
	var stance: String
	var mouse_position = get_viewport().get_mouse_position()
	if mouse_position.y < win_size.y / 3:
		stance = "high"
	elif mouse_position.y < 2 * win_size.y / 3:
		stance = "medium"
	else:
		stance = "low"
	return stance

#renvoie le sprite associé à la stance
func get_stance_sprite(stance):
	var stance_sprite
	if stance == "high":
		stance_sprite = player_high_arm_sprite
	elif stance == "medium":
		stance_sprite = player_medium_arm_sprite
	else:
		stance_sprite = player_low_arm_sprite
	return stance_sprite

#Affiche le bon sprite selon la stance et renvoie ce sprite
func set_stance_sprite(stance):
	if !attacking:
		if stance == "high":
			player_high_arm_sprite.visible = true
			player_medium_arm_sprite.visible = false
			player_low_arm_sprite.visible = false
		elif stance == "medium":
			player_high_arm_sprite.visible = false
			player_medium_arm_sprite.visible = true
			player_low_arm_sprite.visible = false
		else:
			player_high_arm_sprite.visible = false
			player_medium_arm_sprite.visible = false
			player_low_arm_sprite.visible = true

#Retourne là où on regarde se si la souris est à droite où à gauche du perso
func get_looking_direction():
	var mouse_position_x = get_viewport().get_mouse_position().x
	var direction = mouse_position_x - self.position.x
	if direction > 0:
		return 1
	else:
		return -1
