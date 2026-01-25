extends Node2D

@export var combination: Array[bool] = [false, true, false, true]
var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("switch_puzzle ready")
	
func inc() -> void:
	score += 1
	print("score: " + str(score))
	
func dec() -> void:
	score -= 1
	print("score: " + str(score))
		
