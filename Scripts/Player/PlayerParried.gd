extends State
class_name PlayerParried

@export var character:Player
@export var pushed_time:float = 0.5
@export var pushed_distance:int = 100
@export var coef_frott: float = 10

var looking_direction:int
var move_speed:float
var pushed_timer:float

func Enter():	
	character.actual_state = 'parried'
	looking_direction = character.get_looking_direction()
	move_speed = 1000
	pushed_timer = pushed_time

func Exit():
	character.parried = false

func Update(_delta):
	pass

func Physics_Update(delta):
	if pushed_timer >= 0:
		character.global_position.x -= looking_direction * move_speed * delta
		move_speed -=  2000 * delta
		character.move_and_slide()
		pushed_timer -= delta
	else:
		Transiotioned.emit(self,"PlayerCombatMove")
		
