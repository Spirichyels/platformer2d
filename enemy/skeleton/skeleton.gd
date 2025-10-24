extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false
var SPEED = 100
var alive = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	
	if(alive == true):
		if chase == true:
			velocity.x = direction.x * SPEED
			anim.play("Run")
		else:
			velocity.x = 0
			anim.play("Idle")
		if direction.x < 0: anim.flip_h = true
		elif direction.x > 0: anim.flip_h = false 
		move_and_slide()


func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_detector_death_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity.y -= 300
		death()

func _on_detector_death_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if(alive):
			body.HEALTH -= 40
		death()



func death():
	alive = false
	anim.play("Death")
	await anim.animation_finished
	queue_free()
