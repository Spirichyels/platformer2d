extends CanvasLayer



@onready var gold_text: Label = $Control/PanelContainer/HBoxContainer/goldText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	
	gold_text.text = str(Global.gold)
	pass
