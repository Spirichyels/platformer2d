extends CharacterBody2D
signal  heals_changed(new_health)
enum {
	
	MOVE,
	ATTACK1,
	ATTACK2,
	ATTACK3,
	BLOCK,
	SLIDE,
	DAMAGE,
	DEATH,
	MENU
}

const SPEED = 100.0
const FAST_SPEED = 200.0

const JUMP_VELOCITY = -400.0
@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 100
var max_health = 100

var gold = 0
var state = MOVE
var runSpeed = 1
var combo = false
var attack_coldown = false
var player_position

func _ready() -> void:
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	health = max_health


	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
	match state:
		MOVE:
			move_state()
			pass
		ATTACK1:
			attack1_state()
			pass
		ATTACK2:
			attack2_state()	
			pass
		ATTACK3:
			attack3_state()
			pass
		BLOCK:
			block_state()
			pass
		SLIDE:
			slide_state()
			pass
		DAMAGE:
			damage_state()
			pass
		DEATH:
			death_state()
			pass
		MENU:
			get_tree().change_scene_to_file("res://scn/menu/menu.tscn")
	
	player_position = self.position
	Signals.emit_signal("player_position_update", player_position)
		
	#if Input.is_action_just_pressed("attack") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		#animPlayer.play("Jump")
	 
	
	if velocity.y > 0: 
		animPlayer.play("Fall")
		
	
	move_and_slide()
	
	

func move_state():
	
		
	var direction =Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * runSpeed
		if velocity.y == 0:	
			if runSpeed == 1:
				animPlayer.play("Walk")
			elif runSpeed == 2:
				animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0,SPEED)
		if velocity.y == 0:	
			animPlayer.play("Idle")
		
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false
	if Input.is_action_pressed("run"):
		runSpeed = 2
		print(runSpeed)
	else: 
		runSpeed = 1
		print(runSpeed)
		
	if Input.is_action_pressed("block"):
		if (velocity.x == 0):
			state = BLOCK
		else:
			state = SLIDE
	
	if Input.is_action_just_pressed("attack") and attack_coldown == false:
		state = ATTACK1
func block_state():
	velocity.x =0
	animPlayer.play("Block")
	if Input.is_action_just_released("block"):
		state = MOVE
func slide_state():

	animPlayer.play("Slide")
	await animPlayer.animation_finished
	state = MOVE
func attack1_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2
	velocity.x =0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE
func combo1():
	combo = true
	await animPlayer.animation_finished
	combo = false
func attack2_state():
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE
	
func attack3_state():
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE
	
func attack_freeze():
	attack_coldown = true
	await get_tree().create_timer(0.5).timeout
	attack_coldown = false
	
func _on_damage_received(enemy_damage):
	health -= enemy_damage
	
	
	if health <= 0:
		health = 0
		state  = DEATH
	else:
		state = DAMAGE
	
	emit_signal("heals_changed", health)
	
func damage_state():
	velocity.x = 0
	animPlayer.play("Damage")
	await  animPlayer.animation_finished
	state = MOVE
func death_state():
	velocity.x = 0
	animPlayer.play("Death")
	await animPlayer.animation_finished
	#queue_free()
	
	state = MENU
