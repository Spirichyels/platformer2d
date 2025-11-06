extends CanvasLayer

@onready var pathLevel1 = "res://scn/level/level1/level1.tscn"
@onready var pathLevel2 = "res://scn/level/level2/level_2.tscn"


func  _ready() -> void:
	
	#get_tree().change_scene_to_file("res://scn/level/level.tscn") #чтобы пропускать меню
	pass
func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file(pathLevel1)
