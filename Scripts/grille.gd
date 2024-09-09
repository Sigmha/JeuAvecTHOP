extends Node2D


@onready var grille_colision = $grille/grille_colision
@onready var grille = $grille
@onready var camera_2d = $"../../Camera2D"
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animation_player = $AnimationPlayer


var est_passer = false


# Called when the node enters the scene tree for the first time.
func _ready():
	ouvrir_grille()
	camera_2d.position = Vector2(969,-563)
	est_passer = false
	grille.visible = true
	grille_colision.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if est_passer == true:
		fermer_grille()
		changer_pos_cam()
		collision_shape_2d.disabled = true
		est_passer = false
		

func _on_area_2d_body_entered(body):
	if body is Player:
		est_passer = true

func fermer_grille():
	animation_player.play("tombe")

	
func ouvrir_grille():
	animation_player.play("ouvre")
	
func changer_pos_cam():
	camera_2d.position += Vector2(1900,0)
