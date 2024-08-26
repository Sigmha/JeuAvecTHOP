extends State
class_name PlayerCityMove

@export var character:Player
@export var character_collision:CollisionShape2D
@export var city_move_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var move_speed:int = 200

var init_collision_position:Vector2
var immobile_timer: float

func Enter():
	character.actual_state = 'city move'
	city_move_sprite.visible = true
	weapon.disable_weapon()
	
	

func Exit():
	character.touched = false
	city_move_sprite.visible = false
	weapon.enable_weapon()

func Update(_delta):
	pass
	

func Physics_Update(delta):
	var looking_direction:int = character.get_looking_direction()
	var direction = 0
	if Input.is_action_pressed("MoveLeft"):
		direction = -1
	elif  Input.is_action_pressed("MoveRight"):
		direction = 1
	
	set_moving_player(looking_direction, direction)
	character.position.x += direction * move_speed * delta
	
	if character.is_in_fight:
		Transiotioned.emit(self,"PlayerCombatMove")

func set_moving_player(looking_direction, direction):
	if looking_direction == 1:
		city_move_sprite.flip_h = false
	else:
		city_move_sprite.flip_h = true
	
	if direction == 0:
		city_move_sprite.play("Idle")
	elif direction == looking_direction:
		city_move_sprite.play("Walk")
	elif direction != looking_direction:
		city_move_sprite.play_backwards("Walk")
