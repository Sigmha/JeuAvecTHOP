extends ParallaxLayer

var is_Tour_tombe: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_Tour_tombe:
		motion_offset += Vector2(0,5)
		await get_tree().create_timer(1).timeout
		
		is_Tour_tombe = false


