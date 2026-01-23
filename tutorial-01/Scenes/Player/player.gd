extends CharacterBody2D

class_name Player

@export var move_speed: float = 100
@export var push_strength: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = SceneManager.player_spawn_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	__move_player()
	__handle_collision()
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
	elif velocity.x < 0 :
		$AnimatedSprite2D.play("move_left")
	elif velocity.y > 0 :
		$AnimatedSprite2D.play("move_down")
	elif velocity.y < 0 :
		$AnimatedSprite2D.play("move_up")
	else: #velocity == Vector2(0,0)
		$AnimatedSprite2D.stop()
