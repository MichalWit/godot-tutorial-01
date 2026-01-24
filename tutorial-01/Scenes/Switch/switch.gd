extends StaticBody2D

signal switch_on
signal switch_off

var can_interact: bool = false
var on: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		on = !on
		if on:
			$AnimatedSprite2D.play("on")
			switch_on.emit()
		else:
			$AnimatedSprite2D.play("off")
			switch_off.emit()

func _on_switch_on() -> void:
	print("signal received - on")

func _on_switch_off() -> void:
	print("signal received - off")
