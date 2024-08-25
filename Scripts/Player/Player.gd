extends CharacterBody2D
class_name Player

@export var rooling_cooldown:float = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var win_size:Vector2
var is_in_fight:bool = true
var init_collision_player_position:Vector2
var attacking:bool
var touched:bool = false
var ennemy:CharacterBody2D
var rooling_cooldown_timer

@onready var player_collision = $PlayerCollision
@onready var touched_label:Label = $TouchedLabel
@onready var touched_timer:Timer = $TouchedLabel/TouchedTimer
@onready var state_machine = $StateMachine


func _ready():
	rooling_cooldown_timer = 0
	ennemy = get_tree().get_first_node_in_group("Ennemy")
	init_collision_player_position = player_collision.position
	win_size = get_viewport_rect().size

func _physics_process(delta):	
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
	
	if rooling_cooldown_timer > 0:
		rooling_cooldown_timer -= delta
	
	if Input.is_action_just_pressed("ui_focus_next"):
		is_in_fight = !is_in_fight
	
#A CHANGER SI ON CHANGE LE SPRITE, reprendre les mesures pour la position de
#l'épée en idle et en attaque pour les 3 stances
#Retourne la position de l'épée selon la stance et si on attaque ou non
func get_distance_weapon(stance):
	var distance_weapon_idle = []
	var distance_weapon_attack = []
	if stance == "high":
		distance_weapon_idle = [Vector2(8, -23), Vector2(8, -22), Vector2(8, -23), Vector2(8, -24)] 
		distance_weapon_attack = [Vector2(8, -23), Vector2(9, -23), Vector2(16, -22)]
	elif stance == "medium":
		distance_weapon_idle = [Vector2(8, -18), Vector2(8, -17), Vector2(8, -18), Vector2(8, -19)] 
		distance_weapon_attack = [Vector2(8, -18), Vector2(9, -18), Vector2(16, -16)]
	else:
		distance_weapon_idle = [Vector2(8, -10), Vector2(8, -9), Vector2(8, -10), Vector2(8, -11)] 
		distance_weapon_attack = [Vector2(8, -10), Vector2(9, -11), Vector2(16, -9)]
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

