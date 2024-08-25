extends State
class_name PlayerCombatMove

signal changed_stance

@export var character:Player
@export var character_collision:CollisionShape2D
@export var body_sprite:AnimatedSprite2D
@export var arm_sprite:AnimatedSprite2D
@export var weapon:Weapon

var init_collision_position:Vector2
var move_speed := 500
var arm_frame:int
var stance:String

func Enter():
	body_sprite.visible = true
	arm_sprite.visible = true
	character_collision.position.x = character.init_collision_player_position.x
	body_sprite.play("idle")
	_on_changed_stance()

func Exit():
	body_sprite.visible = false
	arm_sprite.visible = false

func Update(_delta):
	pass

func Physics_Update(delta):
	if stance != character.get_stance():
		changed_stance.emit()
	
	var looking_direction:int = character.get_looking_direction()
	var distance_weapon = character.get_distance_weapon(stance)
	arm_frame = arm_sprite.get_frame()
	
	set_looking_side(looking_direction)
	weapon.set_weapon_position(looking_direction, distance_weapon, 0, stance, arm_frame)
	
	var touched = character.touched
	if touched:
		Transiotioned.emit(self,"PlayerHit")
		
	if !character.is_in_fight:
		Transiotioned.emit(self,"PlayerCityMove")
		
	var direction:int = 0
	if Input.is_action_pressed("MoveLeft"):
		direction = -1
	elif  Input.is_action_pressed("MoveRight"):
		direction = 1
	character.position.x += delta * direction * move_speed
	character.move_and_slide()
	
	if Input.is_action_just_pressed("LeftClick"):
		Transiotioned.emit(self,"PlayerAttack")
	
	if Input.is_action_just_pressed("ui_accept") and character.rooling_cooldown_timer <= 0:
		Transiotioned.emit(self,"PlayerRolling")
	
func set_looking_side(looking_direction):
	if looking_direction == 1:
		body_sprite.flip_h = false
		arm_sprite.flip_h = false
	
	elif looking_direction == -1:
		body_sprite.flip_h = true
		arm_sprite.flip_h = true

func set_stance_sprite(new_stance):
	var arm_animation:String
	if new_stance == "high":
		arm_animation= "HighArmIdle"
	elif new_stance == "medium":
		arm_animation = "MediumArmIdle"
	else:
		arm_animation = "LowArmIdle"
	arm_sprite.set_frame(0)
	arm_sprite.play(arm_animation)

func _on_changed_stance():
	stance = character.get_stance()
	set_stance_sprite(stance)
	body_sprite.set_frame(0)
