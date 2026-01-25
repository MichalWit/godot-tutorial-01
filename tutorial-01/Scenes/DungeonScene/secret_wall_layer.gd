extends TileMapLayer

func _ready() -> void:
	__enable_secret_wall()
	
func _on_switch_switch_off() -> void:
	__enable_secret_wall()

func _on_switch_switch_on() -> void:
	__disable_secret_wall()
	
func __disable_secret_wall() -> void:
	visible = false
	collision_enabled = false

func __enable_secret_wall() -> void:
	visible = true
	collision_enabled = true
