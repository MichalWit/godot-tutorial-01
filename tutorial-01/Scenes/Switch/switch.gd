extends StaticBody2D

class_name Switch

signal switch_on
signal switch_off

var can_interact: bool = false
var on: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		if on:
			__turn_off()
			print("turned OFF")
		else:
			__turn_on()
			print("turned ON")

func __turn_on() -> void:
	on = true
	$AnimatedSprite2D.play("on")
	switch_on.emit()

func __turn_off() -> void:
	on = false
	$AnimatedSprite2D.play("off")
	switch_off.emit()
