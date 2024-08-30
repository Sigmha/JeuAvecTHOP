extends Node2D

@onready var player = $Player

const EPEE_CURSEUR_BD = preload("res://Assets/curseur/epeeCurseurBD.png")
const EPEE_CURSEUR_HD = preload("res://Assets/curseur/epeeCurseurHD.png")
const EPEE_CURSEUR_HG = preload("res://Assets/curseur/epeeCurseurHG.png")
const EPEE_CURSEUR_MD = preload("res://Assets/curseur/epeeCurseurMD.png")
const EPEE_CURSEUR_MG = preload("res://Assets/curseur/epeeCurseurMG.png")
const EPEE_CURSEUR_BG = preload("res://Assets/curseur/epeeCurseurBG.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$stance.text = "stance: " + $Player.get_stance()
	close_game()

func close_game():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

