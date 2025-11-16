extends Node

@onready var pause_menu = $"../HUD/PauseMenu"
@onready var player: CharacterBody2D = $"../Player/Player"

var save_path = "user://savegame.save"


var game_paused: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		game_paused  = !game_paused
		
	if game_paused == true:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()
		



func _on_resume_pressed() -> void:
	game_paused  = !game_paused
	
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scn/menu/menu.tscn")
	pass # Replace with function body.


func _on_x_pause_pressed() -> void:
	game_paused  = !game_paused
	
	
	pass # Replace with function body.

func save_game ():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(Global.gold)
	file.store_var(player.position.x)
	file.store_var(player.position.y)
	
	game_paused  = !game_paused
	
	pass

func load_game ():
	var file = FileAccess.open(save_path, FileAccess.READ)
	Global.gold = file.get_var(Global.gold)
	
	player.position.x = file.get_var(player.position.x)
	player.position.y = file.get_var(player.position.y)
	
	
	game_paused  = !game_paused
	
	
	pass
	


func _on_save_pressed() -> void:
	save_game()
	pass # Replace with function body.


func _on_load_pressed() -> void:
	load_game()
	pass # Replace with function body.
