extends Node2D

@onready var player_body_sprite = $BodySprite
@onready var player_high_arm_sprite = $HighArmSprite
@onready var player_medium_arm_sprite = $MediumArmSprite
@onready var player_low_arm_sprite = $LowArmSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#renvoie le sprite associé à la stance
func get_stance_sprite(stance):
	var stance_sprite
	if stance == "high":
		stance_sprite = player_high_arm_sprite
	elif stance == "medium":
		stance_sprite = player_medium_arm_sprite
	else:
		stance_sprite = player_low_arm_sprite
	return stance_sprite

#Affiche le bon sprite selon la stance et renvoie ce sprite
func set_stance_sprite(stance, attacking):
	if !attacking:
		if stance == "high":
			player_high_arm_sprite.visible = true
			player_medium_arm_sprite.visible = false
			player_low_arm_sprite.visible = false
		elif stance == "medium":
			player_high_arm_sprite.visible = false
			player_medium_arm_sprite.visible = true
			player_low_arm_sprite.visible = false
		else:
			player_high_arm_sprite.visible = false
			player_medium_arm_sprite.visible = false
			player_low_arm_sprite.visible = true
