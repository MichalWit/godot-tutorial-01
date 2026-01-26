extends Node2D

var player_spawn_position: Vector2
var opened_chests_ids: Array[String] = []
var collected_chests_names: Array[String] = []

func open_chest(chest_name: String) -> void:
	if !collected_chests_names.has(chest_name):
		collected_chests_names.append(chest_name)
	var index = __find_index(chest_name)
	if index < 0:
		opened_chests_ids.append(chest_name)

func close_chest(chest_name: String) -> void:
	var index = __find_index(chest_name)
	if index >= 0:
		opened_chests_ids.remove_at(index)

func is_open(chest_name: String) -> bool:
	if __find_index(chest_name) >= 0:
		print("chest " + chest_name + " | is OPENED")
		return true
	else:
		print("chest " + chest_name + " | is CLOSED")
		return false

func __find_index(chest_name: String) -> int:
	for i in opened_chests_ids.size():
		if opened_chests_ids[i] == chest_name:
			return i
	return -1
