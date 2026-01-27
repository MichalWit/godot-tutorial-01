extends CharacterBody2D

class_name Player

enum Direction {
	UP, DOWN, LEFT, RIGHT, NONE
}
var direction: Direction = Direction.NONE

var is_attacking: bool = false

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
	is_attacking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_attacking:
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

func __set_direction():
	var move_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_vector * move_speed
	
	if velocity.x > 0 :
		direction = Direction.RIGHT
	elif velocity.x < 0 :
		direction = Direction.LEFT
	elif velocity.y > 0 :
		direction = Direction.DOWN
	elif velocity.y < 0 :
		direction = Direction.UP
	else:
		direction = Direction.NONE

func __move_player() -> void:
	
	__set_direction()
	
	match direction:
		Direction.RIGHT:
			$AnimatedSprite2D.play("move_right")
			$InteractionArea.position = Vector2(8, -8)
		Direction.LEFT:
			$AnimatedSprite2D.play("move_left")
			$InteractionArea.position = Vector2(-8, -8)
		Direction.DOWN:
			$AnimatedSprite2D.play("move_down")
			$InteractionArea.position = Vector2(0, 0)
		Direction.UP:
			$AnimatedSprite2D.play("move_up")
			$InteractionArea.position = Vector2(0, -16)
		Direction.NONE:
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
	is_attacking = true
	__show_sword()
	__play_attack_animation()
	$AttackDurationTimer.start()
	
func __play_attack_animation():
	match direction:
		Direction.RIGHT:
			$AnimatedSprite2D.play("attack_right")
		Direction.LEFT:
			$AnimatedSprite2D.play("attack_left")
		Direction.DOWN:
			$AnimatedSprite2D.play("attack_down")
		Direction.UP:
			$AnimatedSprite2D.play("attack_up")
		Direction.NONE:
			pass

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
