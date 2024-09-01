extends Control

@onready var main_menu = preload("res://Scenes/main_menu.tscn") as PackedScene
@onready var panel_container_option = $PanelContainerOPTION


func _ready():
	resume()

func _process(delta):
	testEsc()

func resume():
	get_tree().paused = false
	panel_container_option.visible = false
	visible = false
	
func afficher_option():
	if panel_container_option.visible == true:
		panel_container_option.visible = false
	else:
		panel_container_option.visible = true
	
func pause():
	get_tree().paused = true
	visible = true
	
func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()

func _on_resume_pressed():
	resume()


func _on_option_pressed():
	afficher_option()


func _on_quitter_pressed():
	get_tree().quit()
	








func _on_retour_pressed():
	afficher_option()
