extends PointLight2D

@onready var timer: Timer = $Timer


enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var day_state = NIGHT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("day_time", Callable(self, "_on_time_changed"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	
	if day_state == NIGHT:
		var rng = randf_range(0.9, 1.2)
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "texture_scale", rng, timer.wait_time)
		tween.parallel().tween_property(self, "energy", rng*2, timer.wait_time)
		timer.wait_time = randf_range(0.3, 0.8)
		pass # Replace with function body.

func _on_time_changed(state):
	day_state = state
	if state == MORNING:
		light_off()
	if state == EVENING:
		light_on()
	pass
	

func light_on():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 2, randi_range(10,20))
	
func light_off():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 0, randi_range(10,20))
