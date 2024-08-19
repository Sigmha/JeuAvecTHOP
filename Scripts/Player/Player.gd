extends CharacterBody2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var win_size: Vector2
var init_collision_player_position:Vector2
var attacking: bool
var touched:bool = false
var ennemy:CharacterBody2D

@onready var player_collision = $PlayerCollision
@onready var touched_label:Label = $TouchedLabel
@onready var touched_timer:Timer = $TouchedLabel/TouchedTimer
@onready var state_machine = $StateMachine


func _ready():
	ennemy = get_tree().get_first_node_in_group("Ennemy")
	init_collision_player_position = player_collision.position
	win_size = get_viewport_rect().size

func _physics_process(delta):	
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
		distance_weapon_idle = Vector2i(8, -23) 
		distance_weapon_attack = Vector2i(16, -23)
	elif stance == "medium":
		distance_weapon_idle = Vector2i(8, -18)
		distance_weapon_attack = Vector2i(16, -17)
	else:
		distance_weapon_idle = Vector2i(8, -10)
		distance_weapon_attack = Vector2i(16, -10)
	return [distance_weapon_idle, distance_weapon_attack]

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

#Retourne là où on regarde se si la souris est à droite où à gauche du perso
func get_looking_direction():
	var mouse_position_x = get_global_mouse_position().x
	var direction = mouse_position_x - self.global_position.x
	if direction > 0:
		return 1
	else:
		return -1

func _on_weapon_dummy_touched():
	touched_label.text = "dummy touched"
	touched_timer.start()

func _on_weapon_weapon_touched():
	touched_label.text = "weapon touched"
	touched_timer.start()

