extends CanvasLayer

signal no_stamina ()

@onready var health_bar = $HealthBar
@onready var stamina_bar = $Stamina

var stamina_cost = 0

var attack_cost = 10
var block_cost = 0.5
var slide_cost = 20
var run_cost = 0.3

var max_health = 120
var stamina = 50:
	set(value):
		stamina = value 
		if stamina < 1:
			emit_signal("no_stamina")
var health:
	set(value):
		health = value
		health_bar.value = int(health)
		

func _ready() -> void:
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health

func _process(delta: float) -> void:
	stamina_bar.value = stamina
	if stamina < 100:
		stamina += 15 * delta

func stamina_consumption():
	stamina -= stamina_cost
	stamina_cost = 0
