extends ParallaxBackground

var SPEED := 30.0


func _process(delta: float):
	scroll_offset.x -= SPEED * delta
