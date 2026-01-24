extends StaticBody2D

var can_interact: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		$CanvasLayer.visible = !$CanvasLayer.visible
		if $CanvasLayer.visible:
			get_tree().paused = true
		else:
			get_tree().paused = false
