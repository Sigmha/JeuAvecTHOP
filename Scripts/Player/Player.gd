extends CharacterBody2D
class_name Player

@export var rooling_cooldown:float = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var win_size:Vector2
var is_in_fight:bool = true
var init_collision_player_position:Vector2
var attacking:bool = false
var touched:bool = false
var parried:bool = false
var is_rolling:bool = false
var rooling_cooldown_timer
var actual_state:String
var actual_stance:String
var actual_looking_direction:int
var dummy:Dummy
var ennemy:Ennemy

@onready var player_collision = $PlayerCollision
@onready var touched_label:Label = $TouchedLabel
@onready var state_machine = $StateMachine

func _ready():
	dummy = get_tree().get_first_node_in_group("Dummy")
	ennemy = get_tree().get_first_node_in_group("Ennemy")
	rooling_cooldown_timer = 0
	init_collision_player_position = player_collision.position
	win_size = get_viewport_rect().size

func _physics_process(delta):
	touched_label.text = str(int(self.global_position.y - get_global_mouse_position().y))
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
	var mouse_position_y = get_global_mouse_position().y
	var dist_to_player = self.global_position.y - mouse_position_y
	if dist_to_player < 11 * global_scale.x:
		stance = "low"
	elif dist_to_player < 22 * global_scale.x:
		stance = "medium"
	else:
		stance = "high"
	actual_stance = stance
	return stance

#Retourne là où on regarde se si la souris est à droite où à gauche du perso
func get_looking_direction():
	var mouse_position_x = get_global_mouse_position().x
	var direction = mouse_position_x - self.global_position.x
	if direction > 0:
		actual_looking_direction = 1
		return 1
	else:
		actual_looking_direction = -1
		return -1

func _on_weapon_dummy_touched():
	pass

func _on_weapon_weapon_touched():
	parried = true

func _on_weapon_ennemy_touched():
	HitStopManager.hit_stop_short()
	ennemy.touched = true
	
