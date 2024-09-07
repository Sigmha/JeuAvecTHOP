extends Area2D
class_name Weapon

signal weapon_touched
signal dummy_touched
signal player_touched
signal ennemy_touched
signal weapon_changed

var weapon_length: int = 16
var collison_weapon_size: Vector2
var play_once_attacking: bool

enum weapon_type {Couteau, Epee, Epee_longue}
var current_weapon
var current_weapon_collision

@onready var weapon_sprite = $WeaponSprite
@onready var epee_collision = $EpeeCollision
@onready var epee_longue_collision = $EpeeLongueCollision
@onready var couteau_collision = $CouteauCollision

@onready var color_rect = $EpeeCollision/ColorRect
@onready var color_rect_2 = $EpeeLongueCollision/ColorRect2
@onready var color_rect_3 = $CouteauCollision/ColorRect3


func _ready():
	current_weapon = weapon_type.Epee
	set_weapon_from_weapon_type()

#Change la position de l'épée en fonction de la direction dans laquelle on
#regarde, si on est en train d'attaquer et la stance.
#La stance se fait automatiquement avec les valeurs données par distance_weapon
func set_weapon_position(looking_direction, distance_weapon, attacking, stance, arm_frame):
	if looking_direction == 1:
		if !attacking:
			if stance == "high":
				rotation = -PI/12
			elif stance == "medium":
				rotation = 0
			else:
				rotation = PI/12
			weapon_sprite.flip_h = false
			position = distance_weapon[0][arm_frame]
			move_weapon_collision(looking_direction)
		elif attacking:
			position = distance_weapon[1][arm_frame]
			rotation = 0
	elif looking_direction == -1:
		if !attacking:
			if stance == "high":
				rotation = PI/12
			elif stance == "medium":
				rotation = 0
			else:
				rotation = -PI/12
			weapon_sprite.flip_h = true
			move_weapon_collision(looking_direction)
			position = Vector2(-1, 1) * distance_weapon[0][arm_frame] - Vector2(weapon_length * cos(rotation), + weapon_length * sin(rotation)) 
		else:
			position = Vector2(-1, 1) * distance_weapon[1][arm_frame] - Vector2(weapon_length, 0)
			rotation = 0

func set_dummy_weapon_position(looking_direction, distance_weapon, attacking, stance):
	if looking_direction == 1:
		if !attacking:
			if stance == "high":
				rotation = -PI/24
			elif stance == "medium":
				rotation = 0
			else:
				rotation = PI/24
			weapon_sprite.flip_h = false
			position = distance_weapon[0]
			epee_collision.position.x = weapon_length - collison_weapon_size.x / 2
		else:
			position = distance_weapon[1]
			rotation = 0
	elif looking_direction == -1:
		if !attacking:
			if stance == "high":
				rotation = PI/24
			elif stance == "medium":
				rotation = 0
			else:
				rotation = -PI/24
			weapon_sprite.flip_h = true
			epee_collision.position.x = collison_weapon_size.x / 2
			position = Vector2(-1, 1) * distance_weapon[0] - Vector2(weapon_length * cos(rotation), + weapon_length * sin(rotation))
		else:
			position = Vector2(-1, 1) * distance_weapon[1] - Vector2(weapon_length, 0)
			rotation = 0

func set_weapon_from_weapon_type():
	match current_weapon:
		weapon_type.Epee:
			weapon_sprite.frame = 0
			collison_weapon_size = epee_collision.shape.size
			epee_collision.disabled = false
			epee_longue_collision.disabled = true
			couteau_collision.disabled = true
			color_rect.visible = true
			color_rect_2.visible = false
			color_rect_3.visible = false
		weapon_type.Epee_longue:
			weapon_sprite.frame = 1
			collison_weapon_size = epee_longue_collision.shape.size
			epee_collision.disabled = true
			epee_longue_collision.disabled = false
			couteau_collision.disabled = true
			color_rect.visible = false
			color_rect_2.visible = true
			color_rect_3.visible = false
		weapon_type.Couteau:
			weapon_sprite.frame = 2
			collison_weapon_size = couteau_collision.shape.size
			epee_longue_collision.disabled = true
			epee_collision.disabled = true
			couteau_collision.disabled = false
			color_rect.visible = false
			color_rect_2.visible = false
			color_rect_3.visible = true

func move_weapon_collision(looking_direction):
	match current_weapon:
		weapon_type.Epee:
			if looking_direction == 1:
				epee_collision.position.x = weapon_length - collison_weapon_size.x / 2
			elif looking_direction == -1:
				epee_collision.position.x = collison_weapon_size.x / 2
		weapon_type.Epee_longue:
			if looking_direction == 1:
				epee_longue_collision.position.x = 20 - collison_weapon_size.x / 2
			elif looking_direction == -1:
				epee_longue_collision.position.x = -4 + collison_weapon_size.x / 2
		weapon_type.Couteau:
			if looking_direction == 1:
				couteau_collision.position.x = 12 - collison_weapon_size.x / 2
			elif looking_direction == -1:
				couteau_collision.position.x = 4 + collison_weapon_size.x / 2

func disable_weapon():
	#$WeaponCollision/ColorRect.visible = false
	weapon_sprite.visible = false
	match current_weapon:
		weapon_type.Epee:
			epee_collision.disabled = true
		weapon_type.Epee_longue:
			epee_longue_collision.disabled = true
		weapon_type.Couteau:
			couteau_collision.disabled = true

func enable_weapon():
	#$WeaponCollision/ColorRect.visible = true
	weapon_sprite.visible = true
	match current_weapon:
		weapon_type.Epee:
			epee_collision.disabled = false
		weapon_type.Epee_longue:
			epee_longue_collision.disabled = false
		weapon_type.Couteau:
			couteau_collision.disabled = false

func _on_body_entered(body):
	if body is Dummy:
		dummy_touched.emit()
	elif body is Player:
		player_touched.emit()
	elif body is Ennemy:
		ennemy_touched.emit()

func _on_area_entered(area):
	if area is Weapon:
		weapon_touched.emit()

func _on_weapon_changed():
	set_weapon_from_weapon_type()
