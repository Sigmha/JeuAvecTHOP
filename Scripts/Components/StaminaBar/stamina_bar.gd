extends HBoxContainer
class_name StaminaBar

const stam_scene = preload("res://Scenes/Components/StaminaBar/stamina.tscn")

func set_max_stam(max_stam:int):
	for i in range(max_stam):
		var stam:Stamina = stam_scene.instantiate()
		add_child(stam)
	
func update_stam(current_stam:int):
	var stam = get_children()
	
	for i in range(current_stam):
		stam[i].update_stam(true)
	
	for i in range(current_stam, stam.size()):
		stam[i].update_stam(false)
