extends StaticBody2D

@export var buttons_needed: int = 1
var buttons_pressed: int = 0

func _on_puzzle_button_pressed() -> void:
	buttons_pressed += 1
	
	if buttons_pressed < buttons_needed:
		visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		
	print("buttons_pressed: " + str(buttons_pressed))


func _on_puzzle_button_unpressed() -> void:
	#if buttons_pressed > 0:
	buttons_pressed -= 1
	
	if buttons_pressed >= buttons_needed:
		visible = true
		$CollisionShape2D.set_deferred("disabled", false)
		
	print("buttons_pressed: " + str(buttons_pressed))
