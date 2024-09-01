extends State
class_name PlayerParried

@export var pushed_time:float = 0.3
@export var stun_time:float = 0.5
@export var up_time:float = 0.05
@export var pushed_velocity:int = 700
@export var coef_frott: float = 2
@export_group("Necessary")
@export var character:Player
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var stun_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var particules_sol:GPUParticles2D
@export var particles_weapon:GPUParticles2D

var move_speed:float
var pushed_timer:float
var stun_timer:float
var up_timer:float
var looking_direction
var arm_frame
var stance
var distance_weapon
var direction:String
var weapon_particle_material:ParticleProcessMaterial
var explosion_position:Vector2

func Enter():
	weapon_particle_material = particles_weapon.get_process_material()
	looking_direction = character.actual_looking_direction
	stance = character.get_stance()
	distance_weapon = character.get_distance_weapon(stance)
	
	particules_sol.emitting = true
	if character.attacking:
		#explosion_position = character.global_position
		#weapon_particle_material.set_emission_shape_offset(Vector3(explosion_position.x, explosion_position.y, 1))
		particles_weapon.position = Vector2(looking_direction, 1) * (distance_weapon[1][arm_sprite.get_frame()] + weapon.weapon_length * Vector2(cos(weapon.rotation), looking_direction * sin(weapon.rotation)) )
	else:
		explosion_position = Vector2(looking_direction, 1) * (distance_weapon[0][arm_sprite.get_frame()] + weapon.weapon_length * Vector2(cos(weapon.rotation), looking_direction * sin(weapon.rotation)) )
		weapon_particle_material.set_emission_shape_offset(Vector3(explosion_position.x, explosion_position.y, 0))
	particles_weapon.emitting = true
	
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
	if character.touched:
		Transiotioned.emit(self,"PlayerHit")
	
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
		Transiotioned.emit(self,"PlayerCombatMove")

func play_stun_animation():
	stun_sprite.speed_scale = 1 / pushed_time
	stun_sprite.visible = true 
	
	if looking_direction == 1:
		direction = '_right'
	elif looking_direction == -1:
		direction = '_left'
	
	stun_sprite.play("down" + direction)
	
