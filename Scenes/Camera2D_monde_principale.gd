extends Camera2D


@onready var player = $"../Player"
var y_en_plus : int = -450



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = postition_joueur(delta)

func postition_joueur(delta):
	var x = lerp(position,player.position, 5*delta)
	var pos = Vector2(x[0],y_en_plus)
	return pos
