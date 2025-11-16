extends Node2D


var coin_preload = preload("res://scn/Collectibles/Coin/coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("enemy_died", Callable (self, "_on_enemy_died"))
	pass # Replace with function body.

func _on_enemy_died(enemy_position, state):
	if state != 4:
		for i in randi_range(1,5):
			coin_spawn(enemy_position)
			await get_tree().create_timer(0.005).timeout
	pass
	
func coin_spawn (coin_position):
	var coin = coin_preload.instantiate()
	coin.position = coin_position
	call_deferred("add_child", coin)
	
