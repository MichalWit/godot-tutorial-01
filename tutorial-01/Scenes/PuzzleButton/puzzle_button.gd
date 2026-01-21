extends Area2D

var bodies_on_top: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	bodies_on_top += 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 1:
			print("pressed")
			$AnimatedSprite2D.play("pressed")


func _on_body_exited(body: Node2D) -> void:
	bodies_on_top -= 1
	if body.is_in_group("pushable") or body is Player:
		if bodies_on_top == 0:
			print("unpressed")
			$AnimatedSprite2D.play("unpressed")
