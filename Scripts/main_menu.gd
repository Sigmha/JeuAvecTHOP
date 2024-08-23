extends Control


@onready var monde_test = preload("res://Scenes/main.tscn") as PackedScene
@onready var monde_principale = preload("res://Scenes/monde_principale.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_monde_test_pressed():
	get_tree().change_scene_to_packed(monde_test)



func _on_button_monde_principale_pressed():
	get_tree().change_scene_to_packed(monde_principale)
	

func _on_button_quitter_pressed():
	get_tree().quit()





