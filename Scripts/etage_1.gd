extends Node2D


@onready var camera_2d = $Camera2D
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	camera_2d.position = Vector2(-952,-882)
	animation_player.play("elevator_monte")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

