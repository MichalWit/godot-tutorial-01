extends CharacterBody2D

var target: Node2D
var speed: int = 15

func _physics_process(delta: float) -> void:
	if target != null:
		var distance: Vector2 = target.global_position - global_position
		var direction: Vector2 = distance.normalized()
		
		velocity = direction * speed
	move_and_slide() # trigger actual movement
		

func _on_player_detection_entered(body: Node2D) -> void:
	if body is Player:
		target = body
