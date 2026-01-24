extends StaticBody2D

var can_interact: bool = false
var dialogue_lines: Array[String] = ["Hello!", "Hi!", "Howdy!"]
var dialogue_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		if dialogue_index < dialogue_lines.size():
			$CanvasLayer.visible = true
			get_tree().paused = true
			__forward_with_dialogue()
			dialogue_index += 1
		else:
			$CanvasLayer.visible = false
			get_tree().paused = false
			dialogue_index = 0
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func __forward_with_dialogue() -> void:
	$CanvasLayer/Dialog.text = dialogue_lines[dialogue_index]
		
