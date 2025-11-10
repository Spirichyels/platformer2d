extends Node2D



@onready var pointLight = $Lights/PointLight2D
@onready var days_text = $HUD/DaysText

@onready var ligtAnimation = $Lights/LightAnimation

@onready var player = $Player/Player

@onready var timerText = $HUD/TimeText

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = NIGHT
var day_count : int
 
func _on_day_night_timeout() -> void:
	#print("timer все")
	match state:
		MORNING:
			morning_state()
			pass
		EVENING:
			evening_state()
			pass
	if state <3: 
		@warning_ignore("int_as_enum_without_cast")
		state+=1
	else: state = MORNING
	#day_count +=1
	#set_day_text()
	#day_text_fade()
	
	pass # Replace with function body.


func _ready() -> void:
	
	#health_bar.max_value = player.max_health
	#health_bar.value = health_bar.max_value
	
	pass
	
	
	#morning_state()
	
	
#	light.enabled = true
	
	#day_text_fade()
	
func _process(_delta: float) -> void:
	
	#print(state)
	pass

func set_day_text():
	days_text.text = "DAY " +str(day_count)
func morning_state():
	
	ligtAnimation.play("sunrise")
	#await get_tree().create_timer(3).timeout
	
	
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(light, "energy", 0.2, 20)	
	#var tween1 = get_tree().create_tween()
	#tween1.tween_property(pointLight, "energy", 0, 20)
	
	
	
	pass
func evening_state():
	ligtAnimation.play("sunset")
	#await get_tree().create_timer(3).timeout
	#var tween = get_tree().create_tween()
	#tween.tween_property(light, "energy", 0.95, 20)
	
	#var tween1 = get_tree().create_tween()
	#tween1.tween_property(pointLight, "energy", 1.5, 20)
	pass


func day_text_fade():
	#animPlayerDayText.play("day_text_fade_in")
	#await get_tree().create_timer(3).timeout
	#animPlayerDayText.play("day_text_fade_out")
	pass
	



# Replace with function body.


func _on_finish_body_entered(_body: Node2D) -> void:
	#print("win")
	#Global.player_health = player.health
	#Global.player_max_health = player.max_health
	
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scn/level/level2/level_2.tscn")
	pass # Replace with function body.
