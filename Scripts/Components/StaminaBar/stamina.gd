extends Panel
class_name Stamina

@onready var color_rect = $ColorRect

func update_stam(whole:bool):
	if whole: color_rect.color = "00bf00"
	else: color_rect.color = "0000003e"

