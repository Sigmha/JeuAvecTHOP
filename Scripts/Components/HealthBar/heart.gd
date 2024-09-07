extends Panel
class_name Heart

@onready var heart_sprite = $HeartSprite

func update_heart(whole:bool):
	if !whole: heart_sprite.frame = 2
	else: heart_sprite.frame = 0
