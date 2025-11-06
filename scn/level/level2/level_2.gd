extends Node2D


@onready var health_bar = $HUD/HealthBar
@onready var player = $Player


func _ready() -> void:
	health_bar.max_value = player.max_health
	health_bar.value = player.health
	
	
func _on_player_heals_changed(new_health: Variant) -> void:
	health_bar.value = new_health
	pass # Replace with function body.
