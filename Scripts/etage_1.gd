extends Node2D


@onready var camera_2d = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	camera_2d.position = Vector2(963,-873)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
