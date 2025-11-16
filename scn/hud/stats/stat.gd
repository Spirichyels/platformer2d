extends CanvasLayer

signal no_stamina ()

@onready var health_bar = $VBoxContainer/HealthBar
@onready var stamina_bar = $VBoxContainer/Stamina
@onready var health_text = $"../HeartsText"
@onready var health_anim = $"../HeartsAnim"



var stamina_cost = 0
var max_health = 120
var attack_cost = 10
var block_cost = 0.5
var slide_cost = 20
var run_cost = 0.3
var old_health = max_health


var stamina = 50:
	set(value):
		stamina = value
		if stamina < 1:
			emit_signal("no_stamina")
var health:
	set(value):
		health = clamp(value, 0,  max_health) 
		health_bar.value = int(health)
		var difference = health - old_health
		health_text.text = str(difference)
		old_health = health
		
		if difference < 0 :
			health_anim.play("damage_received")
		elif difference > 0:
			health_anim.play("health_received")
			
		

func _ready() -> void:
	health_text.modulate.a = 0
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


func _on_hearts_regen_timeout() -> void:
	if health < max_health: 
		health += 1
	pass # Replace with function body.
