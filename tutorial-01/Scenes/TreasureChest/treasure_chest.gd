extends StaticBody2D

var closed: bool = true
var can_interact: bool = true
var collected: bool = false

func _ready() -> void:
	$Scroll.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_interact:
		if closed:
			open()
		else:
			close()
			
func open() -> void:
	$AnimatedSprite2D.play("open")
	$Timer.start()
	if !collected:
		$Scroll.show()
	closed = false
	collected = true
			
func close() -> void:
	$AnimatedSprite2D.play("closed")
	$Scroll.hide()
	$Timer.stop()
	closed = true


func _on_timer_timeout() -> void:
	$Scroll.hide()
