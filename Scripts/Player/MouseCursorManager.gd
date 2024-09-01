extends Node

@export var character:Player

const EPEE_CURSEUR_BD = preload("res://Assets/curseur/epeeCurseurBD.png")
const EPEE_CURSEUR_BG = preload("res://Assets/curseur/epeeCurseurBG.png")
const EPEE_CURSEUR_HD = preload("res://Assets/curseur/epeeCurseurHD.png")
const EPEE_CURSEUR_HG = preload("res://Assets/curseur/epeeCurseurHG.png")
const EPEE_CURSEUR_MD = preload("res://Assets/curseur/epeeCurseurMD.png")
const EPEE_CURSEUR_MG = preload("res://Assets/curseur/epeeCurseurMG.png")

func set_mouse_cursor(stance, looking_direction):
	if looking_direction == 1:
		if stance == "high":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_HD)
		if stance == "medium":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_MD)
		if stance == "low":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_BD)
	elif looking_direction == -1:
		if stance == "high":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_HG)
		if stance == "medium":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_MG)
		if stance == "low":
			Input.set_custom_mouse_cursor(EPEE_CURSEUR_BG)


func _on_player_combat_move_changed_looking_direction():
	set_mouse_cursor(character.actual_stance, character.actual_looking_direction)


func _on_player_combat_move_changed_stance():
	set_mouse_cursor(character.actual_stance, character.actual_looking_direction)
