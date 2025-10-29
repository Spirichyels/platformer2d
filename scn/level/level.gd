extends Node2D

@onready var light = $Lights/DirectionalLight2D
@onready var pointLight = $Lights/PointLight2D
@onready var days_text = $HUD/DaysText
@onready var animPlayerDayText = $HUD/AnimationPlayer

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = MORNING
var day_count : int
 
func _ready() -> void:
	light.enabled = true
	day_count = 1
	day_text_fade()
	
func _process(delta: float) -> void:
	pass


func morning_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 20)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointLight, "energy", 0, 20)
	pass
func evening_state():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.95, 20)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointLight, "energy", 1.5, 20)
	pass

func _on_day_night_timeout() -> void:
	match state:
		MORNING:
			morning_state()
			pass
		EVENING:
			evening_state()
			pass
	if state <3: state+=1
	else: state = MORNING
	day_count +=1
	set_day_text()
	day_text_fade()
	
	pass # Replace with function body.
func day_text_fade():
	animPlayerDayText.play("day_text_fade_in")
	await get_tree().create_timer(3).timeout
	animPlayerDayText.play("day_text_fade_out")
	
func set_day_text():
	days_text.text = "DAY " +str(day_count)
