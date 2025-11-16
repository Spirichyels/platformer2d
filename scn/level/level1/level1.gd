extends Node2D



@onready var pointLight = $Lights/PointLight2D
@onready var days_text = $HUD/DaysText
@onready var ligtAnimation = $Lights/LightAnimation
@onready var player = $Player/Player
@onready var timerText = $HUD/TimeText

var mushroom_preload = preload("res://scn/enemy/mushroom/mushroom.tscn")

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = NIGHT
var day_count : int
 
func _on_day_night_timeout() -> void:
	print("Timer сработал: ",state)
	if state <3: 
		@warning_ignore("int_as_enum_without_cast")
		state+=1
	else: state = MORNING
	
	match state:
		MORNING:
			morning_state()
			pass
		EVENING:
			evening_state()
			pass
	Signals.emit_signal("day_time", state)
	
	print("Timer конец: ",state)
	
	pass # Replace with function body.


func _ready() -> void:
	Global.gold = 0
	day_count = 0
	state = NIGHT
	print(state)
	#morning_state()
	
	pass
	
	
func _process(_delta: float) -> void:
	
	
	pass

	
func morning_state():
	day_count +=1
	ligtAnimation.play("sunrise")
	days_text.text = "DAY " +str(day_count)
	
	
	
	pass
func evening_state():
	ligtAnimation.play("sunset")
	
	pass



func _on_finish_body_entered(_body: Node2D) -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scn/level/level2/level_2.tscn")
	pass # Replace with function body.

func mushroom_spawn():
	var mushroom = mushroom_preload.instantiate()
	mushroom.position = Vector2 (randi_range(-500, 2), 565)
	$Mobs.add_child(mushroom)


func _on_spawner_timeout() -> void:
	mushroom_spawn()
	pass # Replace with function body.
