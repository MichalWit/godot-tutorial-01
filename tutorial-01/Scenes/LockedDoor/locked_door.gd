extends StaticBody2D

@export var buttons_needed: int = 1
var buttons_pressed: int = 0

func _on_puzzle_button_pressed() -> void:
	buttons_pressed += 1
	
	if buttons_pressed >= buttons_needed:
		__open_door()
		
	print(__state())


func _on_puzzle_button_unpressed() -> void:
	buttons_pressed -= 1
	
	if buttons_pressed < buttons_needed:
		__close_door()
		
	print(__state())

func __open_door() -> void:
	print("closing door")
	visible = false # hide
	$CollisionShape2D.set_deferred("disabled", true) # turn off collision
	
func __close_door() -> void:
	print("opening door")
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	
func __state() -> String:
	return "pressed: " + str(buttons_pressed) + " | " \
		+ "needed: " + str(buttons_needed)
