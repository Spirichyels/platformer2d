extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
				pass
			ATTACK:
				attack_state()
				pass
			CHASE:
				chase_state()
				pass
			DAMAGE:
				damage_state()
				pass
			DEATH:
				death_state()
				pass
			RECOVER:
				recover_state()
				pass

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
@onready var AttackDirection = $AttackDirection

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var old_player_pos
var direction
var damage = 20


func _ready() -> void:
	
	pass
	



func damage_state():
	
	animPlayer.play("TakeDamage")
	damage_anim()
	await animPlayer.animation_finished
	
	state = IDLE
	
func damage_anim():
	velocity.x = 0
	
	if direction.x < 0 :
		velocity.x += 150
	elif direction.x > 0:
		velocity.x -= 150
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self, "velocity", Vector2.ZERO, 0.1)
	

func death_state():
	
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()
	
func recover_state():
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	if $AttackDirection/AttackRange.has_overlapping_bodies():
		state = ATTACK
	else :
		state = IDLE
	
func recover_state2():
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	state = IDLE
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if state == CHASE:
		#chase_state()
		pass
	move_and_slide()
	old_player_pos = Global.player_position

func _on_attack_range_body_entered(_body: Node2D) -> void:
	state = ATTACK
	
	pass # Replace with function body.

func idle_state():
	animPlayer.play("Idle")
	state = CHASE
	
func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = RECOVER
	
func chase_state():
	direction = (old_player_pos - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		AttackDirection.rotation_degrees = 180
	else:
		sprite.flip_h = false
		AttackDirection.rotation_degrees = 0
		
	#animPlayer.play("")
	pass
	


func _on_hit_box_area_entered(_area: Area2D) -> void:
	Signals.emit_signal("enemy_attack", damage)
	pass # Replace with function body.




func _on_mob_health_no_health() -> void:
	
	Signals.emit_signal("enemy_died", position, state)
	
	state = DEATH
	pass # Replace with function body.



func _on_mob_health_damage_received() -> void:
	state = IDLE
	state = DAMAGE
	pass # Replace with function body.
