extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	close_game()

func close_game():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
