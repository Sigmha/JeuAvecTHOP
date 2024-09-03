extends HBoxContainer
class_name HeatlhBar

const heart_scene = preload("res://Scenes/Components/HealthBar/heart.tscn")

func set_max_health(max_health:int):
	for i in range(max_health):
		var heart:Heart = heart_scene.instantiate()
		add_child(heart)
	
func update_health(current_health:int):
	var heart = get_children()
	
	for i in range(current_health):
		heart[i].update_heart(true)
	
	for i in range(current_health, heart.size()):
		heart[i].update_heart(false)
