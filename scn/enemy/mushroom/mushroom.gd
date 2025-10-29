extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE
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
				pass

@onready var animPlayer = $AnimationPlayer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _on_attack_range_body_entered(_body: Node2D) -> void:
	state = ATTACK
	print("hello")
	pass # Replace with function body.

func idle_state():
	animPlayer.play("Idle")
	await get_tree().create_timer(1).timeout
	$AttackDirection/AttackRange/CollisionShape2D.disabled = false
	state = CHASE
	
func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	$AttackDirection/AttackRange/CollisionShape2D.disabled = true
	
	state = IDLE
func chase_state():
	
	#animPlayer.play("")
	pass
	
