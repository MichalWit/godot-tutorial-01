extends CharacterBody2D

var target: Node2D
var speed: int = 15
var acceleration: int = 5

enum Direction {
	UP, DOWN, LEFT, RIGHT
}
var direction: Direction = Direction.DOWN
var is_moving: bool = false

func _physics_process(delta: float) -> void:
	__chase_target()
	move_and_slide() # trigger actual movement
	
	__set_direction()
	__play_movement()

func __chase_target() -> void:
	if target != null:
		var distance: Vector2 = target.global_position - global_position
		var direction: Vector2 = distance.normalized()
		
		#velocity = direction * speed
		velocity = velocity.move_toward(direction * speed, acceleration)
		print(velocity)
		
func __play_movement() -> void:
	if is_moving:
		match direction:
			Direction.RIGHT:
				$AnimatedSprite2D.play("move_right")
			Direction.LEFT:
				$AnimatedSprite2D.play("move_left")
			Direction.DOWN:
				$AnimatedSprite2D.play("move_right")
			Direction.UP:
				$AnimatedSprite2D.play("move_up")
	else:
		$AnimatedSprite2D.stop()
	
		

func _on_player_detection_entered(body: Node2D) -> void:
	if body is Player:
		target = body


func __set_direction():
	velocity = velocity.normalized()

	if velocity.x > 0.707 :
		direction = Direction.RIGHT
		is_moving = true
	elif velocity.x < -0.707 :
		direction = Direction.LEFT
		is_moving = true
	elif velocity.y > 0.707 :
		direction = Direction.DOWN
		is_moving = true
	elif velocity.y < -0.707 :
		direction = Direction.UP
		is_moving = true
	else:
		is_moving = false
