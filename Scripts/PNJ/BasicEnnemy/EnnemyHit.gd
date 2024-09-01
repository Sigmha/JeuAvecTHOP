extends State
class_name EnnemyHit

@export var stun_timing: float = 1
@export var pushed_velocity: float = 800
@export var coeff_frott: float = 5
@export_group("Necessary")
@export var character:Ennemy
@export var character_collision:CollisionShape2D
@export var hit_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var particules_sol:GPUParticles2D

var init_collision_position:Vector2
var stun_timer: float
var falling_direction:int

func Enter():
	character.actual_state = 'hit'
	character.parried = false
	hit_sprite.speed_scale = 1 / stun_timing
	stun_timer = stun_timing
	falling_direction = get_falling_direction()
	
	character.set_collision_layer_value(2,false)
	character.set_collision_mask_value(2,false)
	hit_sprite.visible = true
	
	if falling_direction == 1:
		hit_sprite.play("right")
	elif falling_direction == -1:
		hit_sprite.play("left")
	
	weapon.disable_weapon()

func Exit():
	character.set_collision_layer_value(2,true)
	character.set_collision_mask_value(2,true)
	hit_sprite.visible = false
	character.touched = false
	hit_sprite.stop()
	weapon.enable_weapon()

func Update(delta):	
	if stun_timer < 0:
		Transiotioned.emit(self, "EnnemyCombatMove")
	
	stun_timer -= delta
	

func Physics_Update(delta):
	pushed(delta)

func get_falling_direction():
	if character.distance_to_player > 0:
		return 1
	else:
		return -1

func pushed(delta):
	if stun_timing < stun_timer * 13/10:
		character.velocity.x = pushed_velocity
	elif stun_timing < stun_timer * 13/6:
		particules_sol.emitting = true
		character.velocity.x *= exp(- coeff_frott * delta)
	else:
		particules_sol.emitting = false
		character.velocity.x = 0
	character.position.x += - falling_direction * character.velocity.x * delta	
