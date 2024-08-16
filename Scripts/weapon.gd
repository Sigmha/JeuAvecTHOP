extends Area2D

var weapon_length: int = 16
var collison_weapon_size: Vector2i
var play_once_attacking: bool

@onready var weapon_sprite = $WeaponSprite
@onready var weapon_collision = $WeaponCollision

func _ready():
	collison_weapon_size = weapon_collision.shape.size

#Change la position de l'épée en fonction de la direction dans laquelle on
#regarde, si on est en train d'attaquer et la stance.
#La stance se fait automatiquement avec les valeurs données par distance_weapon
func set_weapon_position(looking_direction, distance_weapon, attacking, stance):
	if looking_direction == 1:
		if !attacking:
			if stance == "high":
				rotation = -PI/12
			elif stance == "medium":
				rotation = 0
			else:
				rotation = PI/12
			weapon_sprite.flip_h = false
			position = distance_weapon[0]
			weapon_collision.position.x = weapon_length - collison_weapon_size.x / 2
			play_once_attacking = false
		elif !play_once_attacking:
			position = distance_weapon[1]
			rotation = 0
			play_once_attacking = true
	elif looking_direction == -1:
		if !attacking:
			if stance == "high":
				rotation = PI/12
			elif stance == "medium":
				rotation = 0
			else:
				rotation = -PI/12
			weapon_sprite.flip_h = true
			weapon_collision.position.x = collison_weapon_size.x / 2
			position = Vector2(-1, 1) * distance_weapon[0] - Vector2(weapon_length * cos(rotation), + weapon_length * sin(rotation)) 
			play_once_attacking = false
		elif !play_once_attacking:
			position = Vector2(-1, 1) * distance_weapon[1] - Vector2(weapon_length, 0)
			rotation = 0
			play_once_attacking = true
		
