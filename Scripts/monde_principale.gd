extends Node2D

@onready var animation_player = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	
	animation_player.play("intro")


func _process(_delta):
	close_game()

func close_game():
	pass
