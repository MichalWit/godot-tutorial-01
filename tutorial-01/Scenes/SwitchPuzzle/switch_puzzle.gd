extends Node2D

signal solved
signal unresolved

@export var combination: Array[bool] = [false, true, false, true]
var score: int = 0
var target_score: int = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("switch_puzzle ready")
	
func inc() -> void:
	score += 1
	print("score: " + str(score))
	emit()
	
func dec() -> void:
	score -= 1
	print("score: " + str(score))
	emit()
	
func emit() -> void:
	if score == target_score:
		solved.emit()
	else:
		unresolved.emit()
