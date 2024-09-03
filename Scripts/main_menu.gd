extends Control


@onready var monde_test = preload("res://Scenes/main.tscn") as PackedScene
@onready var monde_principale = preload("res://Scenes/monde_principale.tscn") as PackedScene
@onready var etage_un = preload("res://Scenes/Etages_Tour/etage_1.tscn") as PackedScene

func _on_button_monde_test_pressed():
	get_tree().change_scene_to_packed(monde_test)



func _on_button_monde_principale_pressed():
	get_tree().change_scene_to_packed(monde_principale)
	
	
func _on_button_etage_1_pressed():
	get_tree().change_scene_to_packed(etage_un)
	
	

func _on_button_quitter_pressed():
	get_tree().quit()








