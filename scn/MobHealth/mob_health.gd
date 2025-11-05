extends Node2D

signal no_health()
signal damage_received()

@onready var health_Bar = $HealthBar
@onready var damage_Text = $DamageText
@onready var animPlayer = $AnimationPlayer


var health = 100:
	set (value):
		health = value
		health_Bar.value = health
		if health <= 0:
			health_Bar.visible = false
		else:
			health_Bar.visible = true
		

func _ready() -> void:
	damage_Text.modulate.a = 0
	Signals.connect("player_attack", Callable(self, "_on_damage_received"))
	health_Bar.max_value = health
	health_Bar.visible = false

func _on_damage_received(player_damage):
	health -= player_damage
	animPlayer.stop()
	animPlayer.play("Damage_Text")
	damage_Text.text = str(player_damage)
	if health <=0:
		emit_signal("no_health")
	else:
		emit_signal("damage_received")
	print(player_damage)
	print(health)
	pass
