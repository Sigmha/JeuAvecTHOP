extends Area2D

var is_inside = false

@onready var label = $Label



func _on_body_entered(body):
	if body is Player:
		is_inside = true
		label.text = "z ou fleche haut"

func _on_body_exited(body):
	if body is Player:
		is_inside = false
		label.text = "is_inside = false"


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "is_inside = false"




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_inside == true:
		if Input.is_action_just_pressed("interagir"):
			get_tree().change_scene_to_file("res://Scenes/Etages_Tour/etage_1.tscn")



