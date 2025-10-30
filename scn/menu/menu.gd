extends CanvasLayer


func  _ready() -> void:
	
	#get_tree().change_scene_to_file("res://scn/level/level.tscn") #чтобы пропускать меню
	pass
func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scn/level/level.tscn")
