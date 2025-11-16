extends CharacterBody2D

signal player_finished()


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
const RUN_SPEED = 1.5

const JUMP_VELOCITY = -400.0
@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
@onready var stats = $Stats
@onready var leafs: GPUParticles2D = $Leafs



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



var state = MOVE
var runSpeed = 1


var combo = false
var attack_coldown = false

var damage_basic = 10
var damage_multiplier = 1
var damage_current

var recovery = false

func _ready() -> void:
	Signals.connect("enemy_attack", Callable(self, "_on_damage_received"))
	Signals.emit_signal("player_finished")
	


	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y > 0: 
		animPlayer.play("Fall")
	
	Global.player_damage = damage_basic * damage_multiplier
		
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
	
	
	Global.player_position = self.position
		
		
	
	move_and_slide()
	
	

func move_state():
	
	
		
	var direction =Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * runSpeed
		if velocity.y == 0:	
			if runSpeed == 1:
				animPlayer.play("Walk")
			elif runSpeed == RUN_SPEED:
				stats.stamina -= stats.run_cost
				animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0,SPEED)
		if velocity.y == 0:	
			animPlayer.play("Idle")
		
	if direction == -1:
		anim.flip_h = true
		$AttackDirection.rotation_degrees = 0
	elif direction == 1:
		anim.flip_h = false
		$AttackDirection.rotation_degrees = 180
		
	if Input.is_action_pressed("run") and not recovery:
		
		runSpeed = RUN_SPEED
		
	else: 
		runSpeed = 1
		
		
	if Input.is_action_pressed("block"):
		if not recovery:
			if (velocity.x == 0):
				state = BLOCK
			else:
				stats.stamina_cost = stats.slide_cost
				if stats.stamina_cost < stats.stamina:
					state = SLIDE
	
	if Input.is_action_just_pressed("attack"):
		if not recovery:
			stats.stamina_cost = stats.attack_cost
			if attack_coldown == false and stats.stamina_cost < stats.stamina:
				state = ATTACK1
func block_state():
	if not recovery:
		stats.stamina -= stats.block_cost
		velocity.x =0
		animPlayer.play("Block")
		if Input.is_action_just_released("block") or recovery:
			state = MOVE
func slide_state():
	

	animPlayer.play("Slide")
	await animPlayer.animation_finished
	state = MOVE
func attack1_state():
	stats.stamina_cost = stats.attack_cost
	damage_multiplier = 1
	if Input.is_action_just_pressed("attack") and combo == true and stats.stamina_cost < stats.stamina:
		
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
	stats.stamina_cost = stats.attack_cost
	damage_multiplier = 1.2
	if Input.is_action_just_pressed("attack") and combo == true and stats.stamina_cost < stats.stamina:
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE
	
func attack3_state():
	
	
	damage_multiplier = 2
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE
	
func attack_freeze():
	attack_coldown = true
	await get_tree().create_timer(0.5).timeout
	attack_coldown = false
	
func _on_damage_received(enemy_damage):
	if state ==BLOCK:
		enemy_damage /= 2
	elif state == SLIDE:
		enemy_damage = 0
	else: 
		state = DAMAGE
		damage_anim()
	stats.health -= enemy_damage
	if stats.health <= 0:
		stats.health = 0
		state  = DEATH
	
	
	
func damage_state():
	#velocity.x = 0
	
	animPlayer.play("Damage")
	await  animPlayer.animation_finished
	state = MOVE
	
	
func damage_anim():
	velocity.x = 0
	self.modulate = Color(1,0,0,1)
	if anim.flip_h == true:
		velocity.x += 200
	elif anim.flip_h == false:
		velocity.x -= 200
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2.ZERO, 0.1)
	tween.parallel().tween_property(self, "modulate", Color(1,1,1,1), 0.2)
	
	
	
func death_state():
	velocity.x = 0
	animPlayer.play("Death")
	await animPlayer.animation_finished
	#queue_free()d
	
	state = MENU

func _player_on_finish():
	#print("dfgdfg")
	pass



func _on_player_finished() -> void:
	
	
	
	pass # Replace with function body.


func _on_stats_no_stamina() -> void:
	recovery = true
	await get_tree().create_timer(2).timeout
	recovery = false
	
	pass # Replace with function body.

func steps_leafs ():
	leafs.emitting = true
	leafs.one_shot = true
