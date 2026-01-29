extends CharacterBody2D

class_name Player

var hit_sound = preload("res://NinjaAssetPack/Ninja Adventure - Asset Pack/Audio/Sounds/Hit & Impact/Hit9.wav")
var sword_sound = preload("res://NinjaAssetPack/Ninja Adventure - Asset Pack/Audio/Sounds/Whoosh & Slash/Sword2.wav")

enum Direction {
	UP, DOWN, LEFT, RIGHT
}
var direction: Direction = Direction.DOWN
var is_moving: bool = false
var is_attacking: bool = false
var non_enemy_can_interact: bool = false

@export var move_speed: float = 100
@export var push_strength: float = 100
@export var knockback_strength: float = 200
var acceleration = 10

var sword_sfx: AudioStreamPlayer2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	__hide_sword()
	
	var sword_sfx = AudioStreamPlayer2D.new()
	sword_sfx.stream = sword_sound
	add_child(sword_sfx)
	# https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html#instancing-scenes
	#sword_sfx.owner = get_tree().edited_scene_root # needed only for visibility
	self.sword_sfx = sword_sfx
	
	($DamageSFX as AudioStreamPlayer2D).stream = hit_sound
	
	__update_health_animation()
	if SceneManager.position != Vector2(0,0):
		position = SceneManager.player_spawn_position
		
	var timer: Timer = get_node("AttackDurationTimer")
	timer.timeout.connect(_on_attack_timeout)
	
	var death_timer: Timer = get_node("DeathTimer")
	death_timer.timeout.connect(_on_death_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if SceneManager.player_hp <= 0:
		return # stop displaying attack and movement if dead
	
	if not is_attacking:
		__move_player()
	
	__handle_collision()
	
	if Input.is_action_just_pressed("interact") and not non_enemy_can_interact:
		attack()
	
	%TreasureLabel.text = str(SceneManager.collected_chests_names.size())
	
	move_and_slide()
	
	
func __handle_collision() -> void:
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision != null:
		var collider: Object = collision.get_collider()
		if collider.is_in_group("pushable"):
			var normal: Vector2 = collision.get_normal()
			collider.apply_central_force(-normal * push_strength)
			
		if collider.is_in_group("wall"):
			pass

func __set_direction():
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#velocity = move_vector * move_speed
	velocity = velocity.move_toward(move_vector * move_speed, acceleration)
	
	if velocity.x > 0 :
		direction = Direction.RIGHT
		is_moving = true
	elif velocity.x < 0 :
		direction = Direction.LEFT
		is_moving = true
	elif velocity.y > 0 :
		direction = Direction.DOWN
		is_moving = true
	elif velocity.y < 0 :
		direction = Direction.UP
		is_moving = true
	else:
		is_moving = false

func __move_player() -> void:
	__set_direction()
	__play_move_animation()
	__set_interaction_area()
	
func __set_interaction_area():
	match direction:
		Direction.RIGHT:
			$InteractionArea.position = Vector2(8, -8)
		Direction.LEFT:
			$InteractionArea.position = Vector2(-8, -8)
		Direction.DOWN:
			$InteractionArea.position = Vector2(0, 0)
		Direction.UP:
			$InteractionArea.position = Vector2(0, -16)


func _on_interaction_area_body_entered(body: Node2D) -> void:
	print("func _on_interaction_area_area_entered")
	if body.is_in_group("interactable"):
		print("collider.can_interact = true")
		body.can_interact = true
		non_enemy_can_interact = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	print("_on_interaction_area_area_exited")
	if body.is_in_group("interactable"):
		print("collider.can_interact = false")
		body.can_interact = false
		non_enemy_can_interact = false


func _on_hitbox_area_2d_body_entered(body: Node2D) -> void:
	
	var distance_to_player: Vector2 = global_position - body.global_position
	var knockback_direction: Vector2 = distance_to_player.normalized()
	velocity += knockback_direction * knockback_strength
	print(str(velocity) + " | " +str(knockback_direction) + " | " + str(knockback_strength))
	
	take_hit(body)
	if SceneManager.player_hp <= 0:
		die()

func take_hit(body: Node2D) -> void:
	SceneManager.player_hp -= 1
	__update_health_animation()
	__modulate_color(10)
	
	$DamageSFX.play()
	
	# create anonymous timer, emit 'timeout' after 0.2s
	get_tree()\
		.create_timer(0.2)\
		.timeout\
		.connect(func(): __modulate_color(1))
	
func __modulate_color(value: int):
	($AnimatedSprite2D as AnimatedSprite2D)\
		.modulate = Color(value, value, value)

func __update_health_animation() -> void:
	if SceneManager.player_hp == 3:
		$CanvasLayer/HealthAnimation.play("3")
	elif SceneManager.player_hp == 2:
		$CanvasLayer/HealthAnimation.play("2")
	elif SceneManager.player_hp == 1:
		$CanvasLayer/HealthAnimation.play("1")

func die() -> void:
	($AnimatedSprite2D as AnimatedSprite2D).play("death")
	($DeathTimer as Timer).start()

func _on_death_timer_timeout() -> void:
	SceneManager.player_hp = 3
	get_tree().call_deferred("reload_current_scene")
	
func attack() -> void:
	is_attacking = true
	__show_sword()
	__play_attack_animation()
	$AttackDurationTimer.start()
	sword_sfx.play()
	
	
func _on_attack_timeout() -> void:
	__hide_sword()
	is_attacking = false
	is_moving = true
	__play_move_animation()
	
	
func __play_move_animation():
	if is_moving:
		match direction:
			Direction.RIGHT:
				$AnimatedSprite2D.play("move_right")
			Direction.LEFT:
				$AnimatedSprite2D.play("move_left")
			Direction.DOWN:
				$AnimatedSprite2D.play("move_down")
			Direction.UP:
				$AnimatedSprite2D.play("move_up")
			
	if not is_moving:
		$AnimatedSprite2D.stop()
	
	
func __play_attack_animation():
	match direction:
		Direction.RIGHT:
			$SwordAnimationPlayer.play("attack_right")
			$AnimatedSprite2D.play("attack_right")
		Direction.LEFT:
			$SwordAnimationPlayer.play("attack_left")
			$AnimatedSprite2D.play("attack_left")
		Direction.DOWN:
			$SwordAnimationPlayer.play("attack_down")
			$AnimatedSprite2D.play("attack_down")
		Direction.UP:
			$SwordAnimationPlayer.play("attack_up")
			$AnimatedSprite2D.play("attack_up")

func __show_sword():
	$Sword.visible = true
	$Sword/SwordArea2D.monitoring = true

func __hide_sword():
	$Sword.visible = false
	$Sword/SwordArea2D.monitoring = false

#func _on_area_2d_body_entered(body: Node2D) -> void:
#	pass # Replace with function body.


func _on_sword_area_2d_body_entered(body: Node2D) -> void:
	var distance_to_enemy: Vector2 = body.global_position - global_position
	var knockback_direction: Vector2 = distance_to_enemy.normalized()
	
	body.velocity += knockback_direction * knockback_strength
	body.HP -= 1
	if body.HP <= 0:
		body.queue_free()
	
	if body is SlimeEnemy:
		body.take_hit()
