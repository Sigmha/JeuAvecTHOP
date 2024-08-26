extends State
class_name PlayerParried

@export var character:Player
@export var pushed_time:float = 0.3
@export var stun_time:float = 0.5
@export var up_time:float = 0.05
@export var pushed_velocity:int = 700
@export var coef_frott: float = 2
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var stun_sprite:AnimatedSprite2D
@export var weapon:Weapon


var move_speed:float
var pushed_timer:float
var stun_timer:float
var up_timer:float
var looking_direction
var arm_frame
var stance
var distance_weapon
var direction:String

func Enter():
	looking_direction = character.get_looking_direction()
	stance = character.get_stance()
	distance_weapon = character.get_distance_weapon(stance)
	
	move_speed = pushed_velocity
	pushed_timer = pushed_time
	
	if character.attacking:
		weapon.disable_weapon()
		stun_timer = stun_time
		up_timer = up_time
		character.actual_state = 'stun'
		play_stun_animation()
	else:
		character.actual_state = 'parried'
		stun_timer = 0
		up_timer = 0
		body_sprite.visible = true
		arm_sprite.visible = true

func Exit():
	character.parried = false
	weapon.enable_weapon()
	if character.attacking:
		stun_sprite.visible = false
	else:
		body_sprite.visible = false
		arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	if pushed_timer > 0:
		character.global_position.x -= looking_direction * move_speed * delta
		move_speed *=  exp(-coef_frott * delta)
		character.move_and_slide()
		pushed_timer -= delta
		
		arm_frame = arm_sprite.get_frame()
		weapon.set_weapon_position(looking_direction, distance_weapon, 0, stance, arm_frame)
		character.touched = false
	elif stun_timer > 0:
		stun_timer -= delta
	elif up_timer > 0:
		stun_sprite.speed_scale = 1 / up_timer
		stun_sprite.play("up" + direction)
		up_timer -= delta
	else:
		Transiotioned.emit(self,"PlayerCombatMove")

func play_stun_animation():
	stun_sprite.speed_scale = 1 / pushed_time
	stun_sprite.visible = true 
	
	if looking_direction == 1:
		direction = '_right'
	elif looking_direction == -1:
		direction = '_left'
	
	stun_sprite.play("down" + direction)
	
