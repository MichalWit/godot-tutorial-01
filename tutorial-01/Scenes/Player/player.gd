extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var push_strength: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	__hide_sword()
	
	__update_health_animation()
	if SceneManager.position != Vector2(0,0):
		position = SceneManager.player_spawn_position
		
	var timer = get_node("AttackDurationTimer")
	timer.timeout.connect(_on_attack_timeout)

func _on_attack_timeout() -> void:
	__hide_sword()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	__move_player()
	__handle_collision()
	
	if Input.is_action_just_pressed("interact"):
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
			print("wall")


func __move_player() -> void:
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_vector * move_speed
	
	if velocity.x > 0 :
		$AnimatedSprite2D.play("move_right")
		$InteractionArea.position = Vector2(8, -8)
	elif velocity.x < 0 :
		$AnimatedSprite2D.play("move_left")
		$InteractionArea.position = Vector2(-8, -8)
	elif velocity.y > 0 :
		$AnimatedSprite2D.play("move_down")
		$InteractionArea.position = Vector2(0, 0)
	elif velocity.y < 0 :
		$AnimatedSprite2D.play("move_up")
		$InteractionArea.position = Vector2(0, -16)
	else: #velocity == Vector2(0,0)
		$AnimatedSprite2D.stop()


func _on_interaction_area_body_entered(body: Node2D) -> void:
	print("func _on_interaction_area_area_entered")
	if body.is_in_group("interactable"):
		print("collider.can_interact = true")
		body.can_interact = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	print("_on_interaction_area_area_exited")
	if body.is_in_group("interactable"):
		print("collider.can_interact = false")
		body.can_interact = false


func _on_hitbox_area_2d_body_entered(body: Node2D) -> void:
	take_hit()
	if SceneManager.player_hp <= 0:
		die()

func take_hit() -> void:
	SceneManager.player_hp -= 1
	__update_health_animation()

func __update_health_animation() -> void:
	if SceneManager.player_hp == 3:
		$CanvasLayer/HealthAnimation.play("3")
	elif SceneManager.player_hp == 2:
		$CanvasLayer/HealthAnimation.play("2")
	elif SceneManager.player_hp == 1:
		$CanvasLayer/HealthAnimation.play("1")

func die() -> void:
	SceneManager.player_hp = 3
	get_tree().call_deferred("reload_current_scene")
	
func attack() -> void:
	__show_sword()
	$AttackDurationTimer.start()

func __show_sword():
	$Sword.visible = true
	$Sword/SwordArea2D.monitoring = true

func __hide_sword():
	$Sword.visible = false
	$Sword/SwordArea2D.monitoring = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_sword_area_2d_body_entered(body: Node2D) -> void:
	body.queue_free() # delete node and all its children
