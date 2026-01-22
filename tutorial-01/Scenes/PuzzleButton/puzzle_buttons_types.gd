@abstract class BasePuzzleButton extends Area2D:
	
	signal pressed
	signal unpressed
	
	var bodies_on_top: int = 0
	
	func _on_body_entered(body: Node2D) -> void:
		bodies_on_top += 1
		if body.is_in_group("pushable") or body is Player:
			if bodies_on_top == 1:
				print("pressed")
				$AnimatedSprite2D.play("pressed")
				pressed.emit()


	func _on_body_exited(body: Node2D) -> void:
		process_exited(body)

	@abstract func process_exited(body: Node2D) -> void


class MultiUsePuzzleButton extends BasePuzzleButton:
	
	func process_exited(body: Node2D) -> void:
		print("MultiUsePuzzleButton.process_exited")
		bodies_on_top -= 1
		if body.is_in_group("pushable") or body is Player:
			if bodies_on_top == 0:
				print("unpressed")
				$AnimatedSprite2D.play("unpressed")
				unpressed.emit()


class SingleUsePuzzleButton extends BasePuzzleButton:
	
	func process_exited(body: Node2D) -> void:
		print("SingleUsePuzzleButton.process_exited")
