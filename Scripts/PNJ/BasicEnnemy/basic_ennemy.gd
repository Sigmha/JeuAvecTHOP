extends CharacterBody2D
class_name Ennemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var win_size:Vector2
var init_collision_ennemy_position:Vector2
var attacking:bool = false
var touched:bool = false
var parried:bool = false
var player:CharacterBody2D
var actual_state:String

@onready var ennemy_collision = $PlayerCollision
@onready var state_machine = $StateMachine


func _ready():
	player = get_tree().get_first_node_in_group("Joueur")
	init_collision_ennemy_position = ennemy_collision.position
	win_size = get_viewport_rect().size

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

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
func new_stance():
	var stance_tab = ["high", "medium", "low"]
	var rand_stance = randi_range(0, 2)
	return stance_tab[rand_stance]

#Retourne là où on regarde se si la souris est à droite où à gauche du perso
func get_looking_direction():
	var player_position_x = player.global_position.x
	var direction = player_position_x - self.global_position.x
	if direction > 0:
		return 1
	else:
		return -1

func _on_weapon_weapon_touched():
	parried = true

