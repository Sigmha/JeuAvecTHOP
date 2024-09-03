extends State
class_name EnnemyParried

@export var pushed_time:float = 0.3
@export var stun_time:float = 0.5
@export var up_time:float = 0.05
@export var pushed_velocity:int = 700
@export var coef_frott: float = 2
@export_group("Necessary")
@export var character:Ennemy
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var stun_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var particules_sol:GPUParticles2D

var move_speed:float
var pushed_timer:float
var stun_timer:float
var up_timer:float
var looking_direction
var arm_frame
var stance
var distance_weapon
var direction:String
var stun:bool

func Enter():
	looking_direction = character.get_looking_direction()
	stance = character.actual_stance
	distance_weapon = character.get_distance_weapon(stance)
	
	particules_sol.emitting = true
	move_speed = pushed_velocity
	pushed_timer = pushed_time
	
	if character.player.is_parring:
		weapon.disable_weapon()
		stun = true
		stun_timer = stun_time
		up_timer = up_time
		character.actual_state = 'stun'
		play_stun_animation()
	else:
		character.actual_state = 'parried'
		stun_timer = 0
		up_timer = 0
		stun = false
		body_sprite.visible = true
		arm_sprite.visible = true

func Exit():
	character.parried = false
	weapon.enable_weapon()
	if stun:
		stun_sprite.visible = false
	else:
		body_sprite.visible = false
		arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	if character.touched and character.current_health <= character.player.attack_damage:
		Transiotioned.emit(self,"EnnemyDying")
	elif character.touched and character.current_health > character.player.attack_damage:
		Transiotioned.emit(self,"EnnemyHit")
	
	if pushed_timer > 0:
		character.global_position.x -= looking_direction * move_speed * delta
		move_speed *=  exp(-coef_frott * delta)
		pushed_timer -= delta
		character.touched = false
		
		character.move_and_slide()
		arm_frame = arm_sprite.get_frame()
		weapon.set_weapon_position(looking_direction, distance_weapon, 0, stance, arm_frame)
	elif stun_timer > 0:
		particules_sol.emitting = false
		stun_timer -= delta
	elif up_timer > 0:
		stun_sprite.speed_scale = 1 / up_timer
		stun_sprite.play("up" + direction)
		up_timer -= delta
	else:
		particules_sol.emitting = false
		Transiotioned.emit(self,"EnnemyCombatMove")

func play_stun_animation():
	stun_sprite.speed_scale = 1 / pushed_time
	stun_sprite.visible = true 
	
	if looking_direction == 1:
		direction = '_right'
	elif looking_direction == -1:
		direction = '_left'
	
	stun_sprite.play("down" + direction)
	
