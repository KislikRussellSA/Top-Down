extends CharacterBody2D
class_name Skeleton

@export var walk_speed = 50
enum states {IDLE, CHASE, ATTACK, HURT, DEAD}
var prev
var state = states.IDLE
var player
var health = 3
var hit = false
var death = false
var s_r = false
var s_l = false
var damage = false

func _physics_process(delta):
	choose_action()
	move_and_slide()
	
func choose_action():
	match state:
		states.IDLE:
			$AnimatedSprite2D.play("idle")
			velocity = Vector2.ZERO
		states.CHASE:
			$AnimatedSprite2D.play("running")
			if player.position.x > position.x:
				velocity = position.direction_to(player.position + Vector2(20, -5)) * walk_speed
				if velocity.x != 0:
					transform.x.x = sign(velocity.x)
			else:
				velocity = position.direction_to(player.position + Vector2(-20, -5)) * walk_speed
				if velocity.x != 0:
					transform.x.x = sign(velocity.x)
			
		states.ATTACK:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("attack")
			if (s_l or s_r) and damage:
				player.hurt()
				damage = false
		states.DEAD:
			velocity = Vector2.ZERO
			$AnimatedSprite2D.play("death")
			await $AnimatedSprite2D.animation_looped
			queue_free()

func _on_attack_a_body_entered(body: Node2D) -> void:
	if not death:
		state = states.ATTACK


func _on_attack_a_body_exited(body: Node2D) -> void:
	if not death:
		state = states.CHASE


func _on_chase_a_body_entered(body: Node2D) -> void:
	player = body
	player.hurt_u.connect(lose_health_u)
	player.hurt_l.connect(lose_health_l)
	player.hurt_r.connect(lose_health_r)
	player.hurt_d.connect(lose_health_d)
	player.stop.connect(stop)
	if not death:
		state = states.CHASE


func _on_chase_a_body_exited(body: Node2D) -> void:
	player.hurt_u.disconnect(lose_health_u)
	player.hurt_l.disconnect(lose_health_l)
	player.hurt_r.disconnect(lose_health_r)
	player.hurt_d.disconnect(lose_health_d)
	player.stop.disconnect(stop)
	player = null
	if not death:
		state = states.IDLE



func lose_health_u():
	if player.position.y > position.y:
		if health > 0:
			health -= 1
			$Health.update_simple(health)
		if health <= 0:
			death = true
			state = states.DEAD
	else:
		pass

func lose_health_d():
	if player.position.y < position.y:
		if health > 0:
			health -= 1
			$Health.update_simple(health)
		if health <= 0:
			death = true
			state = states.DEAD
	else:
		pass

func lose_health_r():
	if player.position.x < position.x:
		if health > 0:
			health -= 1
			$Health.update_simple(health)
		if health <= 0:
			death = true
			state = states.DEAD
	else:
		pass
			
func lose_health_l():
	if player.position.x > position.x:
		if health > 0:
			health -= 1
			$Health.update_simple(health)
		if health <= 0:
			death = true
			state = states.DEAD
	else:
		pass


func _on_hurt_r_body_entered(body: Node2D) -> void:
	s_r = true


func _on_hurt_r_body_exited(body: Node2D) -> void:
	s_r = false


func _on_hurt_l_body_entered(body: Node2D) -> void:
	s_l = true


func _on_hurt_l_body_exited(body: Node2D) -> void:
	s_l = false


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame == 3:
		damage = true


func _on_animated_sprite_2d_animation_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		damage = false

func stop():
	state = states.IDLE
