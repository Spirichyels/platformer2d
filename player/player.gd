extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var anim = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var HEALTH = 100
var gold = 0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0: anim.play("Fall")
	if Input.is_action_just_pressed("attack") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		
	var direction =Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:	anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0,SPEED)
		if velocity.y == 0:	anim.play("Idle")
	 
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction == 1:
		$AnimatedSprite2D.flip_h = false
		
	if(HEALTH <=0):
		queue_free()
		get_tree().change_scene_to_file("res://ui/menu/menu.tscn")
	move_and_slide()
	
	
		
