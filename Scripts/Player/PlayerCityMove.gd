extends State
class_name PlayerCityMove

signal changed_movement
signal changed_looking_side

@export var move_speed:int = 200
@export_group("Necessary")
@export var character:Player
@export var character_collision:CollisionShape2D
@export var city_move_sprite:AnimatedSprite2D
@export var weapon:Weapon

var init_collision_position:Vector2
var immobile_timer:float
var direction:int
var looking_direction:int

func Enter():
	character.actual_state = 'city move'
	city_move_sprite.visible = true
	weapon.disable_weapon()
	looking_direction = character.get_looking_direction()
	set_moving_player()
	
	

func Exit():
	character.touched = false
	city_move_sprite.visible = false
	weapon.enable_weapon()

func Update(_delta):
	pass

func Physics_Update(delta):
	var new_direction = 0
	if Input.is_action_pressed("MoveLeft"):
		new_direction = -1
	elif  Input.is_action_pressed("MoveRight"):
		new_direction = 1
	
	if new_direction != direction:
		direction = new_direction
		changed_movement.emit()
	if looking_direction != character.get_looking_direction():
		looking_direction = character.get_looking_direction()
		changed_looking_side.emit()
	
	character.position.x += direction * move_speed * delta
	
	if character.is_in_fight:
		Transiotioned.emit(self,"PlayerCombatMove")

func set_moving_player():
	var animation_direction:String
	if looking_direction == 1:
		animation_direction = "_right"
	else:
		animation_direction = "_left"
	
	if direction == 0:
		city_move_sprite.play("Idle" + animation_direction)
	elif direction == looking_direction:
		city_move_sprite.play("Walk" + animation_direction)
	elif direction != looking_direction:
		city_move_sprite.play("Walk" + animation_direction, -1)

func _on_changed_movement():
	set_moving_player()

func _on_changed_looking_side():
	set_moving_player()
