extends StaticBody2D

func _ready() -> void:
	pass
	#visible = true

func _on_puzzle_button_pressed() -> void:
	visible = !visible
	if visible == false:
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		$CollisionShape2D.set_deferred("disabled", false)


func _on_puzzle_button_unpressed() -> void:
	#print("_on_puzzle_button_unpressed signal received")
	pass
