extends CharacterBody2D
class_name Player

@export var max_health:int = 4
@export var max_stam:int = 4
@export var rooling_cooldown:float = 1
@export var attack_damage:int = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var win_size:Vector2
var init_collision_player_position:Vector2
#State booleen
var is_in_fight:bool = true
var attacking:bool = false
var touched:bool = false
var parried:bool = false
var is_rolling:bool = false
var is_parring:bool = false
#timers
var rooling_cooldown_timer
#truc dans l'instant
var actual_state:String
var actual_stance:String
var current_health:int
var current_stam:int
var actual_looking_direction:int
#Other characters
var dummy:Dummy
var ennemy:Ennemy

@onready var player_collision = $PlayerCollision
@onready var touched_label:Label = $TouchedLabel
@onready var state_machine = $StateMachine
@onready var health_bar:HeatlhBar = $CanvasLayer/HealthBar
@onready var stamina_bar:StaminaBar = $StaminaBar
@onready var parrying_timer = $Timers/ParryingTimer
@onready var weapon = $Weapon

func _ready():
	health_bar.set_max_health(max_health)
	current_health = max_health
	health_bar.update_health(current_health)
	
	stamina_bar.set_max_stam(max_stam)
	current_stam = max_stam
	stamina_bar.update_stam(current_stam)
	
	dummy = get_tree().get_first_node_in_group("Dummy")
	ennemy = get_tree().get_first_node_in_group("Ennemy")
	rooling_cooldown_timer = 0
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
	if ennemy.current_health == 1:
		HitStopManager.hit_stop_short()
	ennemy.touched = true

func _on_parrying_timer_timeout():
	weapon.set_modulate("ffffff")
	is_parring = false
