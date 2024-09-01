extends State
class_name PlayerDying

@export var animation_timing: float = 1
@export var pushed_velocity: float = 800
@export var coeff_frott: float = 5
@export_group("Necessary")
@export var character:Player
@export var character_collision:CollisionShape2D
@export var hit_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var particules_sol:GPUParticles2D

var ennemy:Ennemy
var falling_direction:int
var animation_timer:float

func Enter():
	animation_timer = animation_timing
	character.health_bar.update_health(0)
	hit_sprite.speed_scale = 1 / animation_timing
	ennemy = character.ennemy
	falling_direction = get_falling_direction()
	
	character.set_collision_layer_value(2,false)
	character.set_collision_mask_value(2,false)
	hit_sprite.visible = true
	
	if falling_direction == 1:
		hit_sprite.play("dying_right")
	elif falling_direction == -1:
		hit_sprite.play("dying_left")
	
	weapon.disable_weapon()

func Exit():
	character.touched = false
	hit_sprite.stop()

func Update(_delta):
	pass

func Physics_Update(delta):
	pushed(delta)

func get_falling_direction():
	var direction = ennemy.global_position.x - character.global_position.x
	if direction > 0:
		return 1
	else:
		return -1

func pushed(delta):
	if hit_sprite.frame <= 2:
		character.velocity.x = pushed_velocity
		animation_timer -= delta
	elif animation_timer >= 0:
		particules_sol.emitting = true
		character.velocity.x *= exp(- coeff_frott * delta)
		animation_timer -= delta
	else:
		particules_sol.emitting = false
		character.velocity.x = 0
		await get_tree().create_timer(1).timeout
		respawn()
	character.position.x += - falling_direction * character.velocity.x * delta

func respawn():
	get_tree().reload_current_scene()

