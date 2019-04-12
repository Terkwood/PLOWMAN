extends Node2D

onready var _scene_storage = preload("res://SceneStorage.gd").new()

# Cleanup all chunks data on exit
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_scene_storage.delete_all_scene_data()
		get_tree().quit() # default behavior