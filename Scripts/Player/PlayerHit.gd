extends State
class_name PlayerHit

@export var character:Player
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var hit_sprite:AnimatedSprite2D
@export var weapon:Weapon
@export var stun_timing: float = 1
@export var pushed_velocity: float = 200
@export var coeff_frott: float = 10

var init_collision_position:Vector2
var stun_timer: float
var ennemy:CharacterBody2D
var falling_direction:int

func Enter():
	hit_sprite.speed_scale = 1 / stun_timing
	stun_timer = stun_timing
	
	ennemy = character.ennemy
	falling_direction = get_falling_direction()
	
	character.set_collision_layer_value(2,false)
	character.set_collision_mask_value(2,false)
	body_sprite.visible = false
	arm_sprite.visible = false
	hit_sprite.visible = true
	
	hit_sprite.play("default")
	weapon.disable_weapon()

func Exit():
	character.set_collision_layer_value(2,true)
	character.set_collision_mask_value(2,true)
	body_sprite.visible = true
	arm_sprite.visible = true
	hit_sprite.visible = false
	
	hit_sprite.stop()
	weapon.enable_weapon()

func Update(delta):	
	if stun_timer < 0:
		Transiotioned.emit(self, "PlayerCombatMove")
		character.touched = false
	
	stun_timer -= delta
	

func Physics_Update(delta):
	pushed(delta)

func get_falling_direction():
	var direction = ennemy.global_position.x - character.global_position.x
	if direction > 0:
		hit_sprite.flip_h = false
		return 1
	else:
		hit_sprite.flip_h = true
		return -1

func pushed(delta):
	if stun_timing < stun_timer * 14/10:
		character.velocity.x = 500
	elif stun_timing < stun_timer * 14/6:
		character.velocity.x = character.velocity.x * exp(- coeff_frott * delta)
	else:
		character.velocity.x = 0
	character.position.x += - falling_direction * character.velocity.x * delta	
