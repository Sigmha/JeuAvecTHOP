extends State
class_name PlayerRolling

@export var rolling_time:float = 0.5
@export var rolling_distance:float = 400
@export_group("Necessary")
@export var character:Player
@export var character_collision:CollisionShape2D
@export var rolling_sprite:AnimatedSprite2D
@export var weapon:Weapon

var init_collision_position:Vector2
var rolling_speed:float 
var rolling_timer:float
var looking_direction:int

func Enter():
	character.is_rolling = true
	character.actual_state = 'rooling'
	rolling_sprite.speed_scale = 1 / rolling_time
	rolling_speed = rolling_distance / rolling_time
	rolling_timer = rolling_time
	
	character.rooling_cooldown_timer = character.rooling_cooldown
	character.set_collision_layer_value(2,false)
	character.set_collision_mask_value(2,false)
	rolling_sprite.visible = true
	
	looking_direction = character.get_looking_direction()
	
	play_rolling()
	weapon.disable_weapon()

func Exit():
	rolling_sprite.visible = false
	character.is_rolling = false
	character.set_collision_layer_value(2,true)
	character.set_collision_mask_value(2,true)
	rolling_sprite.stop()
	weapon.enable_weapon()

func Update(_delta):
	pass

func Physics_Update(delta):
	if rolling_timer >= 0:
		character.position.x += delta * looking_direction * rolling_speed
		rolling_timer -= delta
	else:
		Transiotioned.emit(self,"PlayerCombatMove")

func play_rolling():
	if looking_direction == 1:
		rolling_sprite.play("right")
	
	elif looking_direction == -1:
		rolling_sprite.play("left")
