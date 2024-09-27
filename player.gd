extends CharacterBody2D

class_name Player
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var cur_dir = "right"
var attack = false
var pos = position
var health = 5
var a_u = false
var a_d = false
var a_l = false
var a_r = false
signal hurt_u
signal hurt_d
signal hurt_l
signal hurt_r
signal health_changed
signal stop
var stopped = false

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
		#$AnimatedSprite2D.play("run_right")
		#if Input.is_action_pressed("ui_left"):
			#$AnimatedSprite2D.flip_h = true
		#if Input.is_action_pressed("ui_right"):
			#$AnimatedSprite2D.flip_h = false
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#var vertical := Input.get_axis("ui_up", "ui_down")
	#if vertical:
		#velocity.y = vertical * SPEED
		#if Input.is_action_pressed("ui_up"):
			#$AnimatedSprite2D.play("run_back")
		#if Input.is_action_pressed("ui_down"):
			#$AnimatedSprite2D.play("run_front")
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	#if not (direction and vertical):
		#$AnimatedSprite2D.play("idle_right")
	if not stopped:
		if attack:
			await $AnimatedSprite2D.animation_looped
			attack = false
			position = pos
		var direction = Input.get_vector("left", "right", "up", "down")
		if not Input.is_anything_pressed() and not attack:
			match cur_dir:
				"down":
					$AnimatedSprite2D.play("idle_front")
				"up":
					$AnimatedSprite2D.play("idle_back")
				"left":
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.play("idle_right")
				"right":
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("idle_right")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
		else:
			if Input.is_action_pressed("down"):
				$AnimatedSprite2D.play("run_front")
				cur_dir = "down"
			elif Input.is_action_pressed("up"):
				$AnimatedSprite2D.play("run_back")
				cur_dir = "up"
			elif Input.is_action_pressed("left"):
				$AnimatedSprite2D.play("run_right")
				cur_dir = "left"
				$AnimatedSprite2D.flip_h = true
			elif Input.is_action_pressed("right"):
				cur_dir = "right"
				$AnimatedSprite2D.play("run_right")
				$AnimatedSprite2D.flip_h = false
			velocity = direction * SPEED
			
		if Input.is_action_just_pressed("click"):
			match cur_dir:
				"down":
					$AnimatedSprite2D.play("attack_front")
					if a_d:
						await $AnimatedSprite2D.frame == 3
						emit_signal("hurt_d")
				"up":
					$AnimatedSprite2D.play("attack_back")
					if a_u:
						await $AnimatedSprite2D.frame == 3
						emit_signal("hurt_u")
				"left":
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.play("attack_right")
					if a_l:
						await $AnimatedSprite2D.frame == 3
						emit_signal("hurt_l")
				"right":
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play("attack_right")
					if a_r:
						await $AnimatedSprite2D.frame == 3
						emit_signal("hurt_r")
			attack = true
			pos = position
		move_and_slide()


func _on_hurt_l_body_entered(body: Node2D) -> void:
	a_l = true


func _on_hurt_l_body_exited(body: Node2D) -> void:
	a_l = false


func _on_hurt_d_body_entered(body: Node2D) -> void:
	a_d = true


func _on_hurt_d_body_exited(body: Node2D) -> void:
	a_d = false


func _on_hurt_u_body_entered(body: Node2D) -> void:
	a_u = true


func _on_hurt_u_body_exited(body: Node2D) -> void:
	a_u = false


func _on_hurt_r_body_entered(body: Node2D) -> void:
	a_r = true


func _on_hurt_r_body_exited(body: Node2D) -> void:
	a_r = false
	
func hurt():
	health -= 1
	emit_signal("health_changed", health)
	if health == 0:
		emit_signal("stop")
		stopped = true
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_looped
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 2
		
