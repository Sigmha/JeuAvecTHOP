extends CharacterBody2D
class_name Dummy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var init_collision_player_position:Vector2
var player:Player

@onready var collision = $DummyCollision
@onready var touched_label:Label = $TouchedLabel
@onready var touched_timer:Timer = $TouchedLabel/TouchedTimer

func _ready():
	player = get_tree().get_first_node_in_group("Joueur")
	init_collision_player_position = collision.position

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

#Renvoie la stance actuelle
func get_stance():
	var stance_tab = ["high", "medium", "low"]
	var rand_stance = randi_range(0, 2)
	return stance_tab[rand_stance]

func _on_weapon_player_touched():
	player.touched = true
	touched_label.text = "player touched"
	touched_timer.start()

func _on_weapon_weapon_touched():
	touched_label.text = "weapon touched"
	touched_timer.start()
