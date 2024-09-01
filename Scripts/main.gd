extends Node2D

@onready var player = $Player
@onready var fps = $Camera2D/FPS

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fps.text = "FPS " + str(Engine.get_frames_per_second())
	$stance.text = "stance: " + $Player.get_stance()
	close_game()

func close_game():
	pass

