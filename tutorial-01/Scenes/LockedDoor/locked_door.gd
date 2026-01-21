extends StaticBody2D

func _ready() -> void:
	visible = true

func _on_puzzle_button_pressed() -> void:
	visible = !visible
	print("_on_puzzle_button_pressed signal received")


func _on_puzzle_button_unpressed() -> void:
	print("_on_puzzle_button_unpressed signal received")
