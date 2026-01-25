extends Node2D

class_name SwitchPuzzle

@export var combination: Array[bool] = [false, true, false, true]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in combination:
		var switch = Switch.new()
		add_child(switch)
