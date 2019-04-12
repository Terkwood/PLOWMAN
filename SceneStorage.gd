extends Node

func save_scene(node: Node, name: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var file = "user://%s.tscn" % name
	ResourceSaver.save(file, packed_scene)

func load_scene(file_name: String):
	var packed_scene = load("user://%s.tscn" % file_name)
	var i = packed_scene.instance()
	return i

func delete_all_scene_data():
	var dir = Directory.new()
	if dir.open("user://") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if !dir.current_is_dir():
				if ".tscn" in file_name:
					if dir.remove(file_name) != OK:
						print("An error occurred when trying to delete %s" % file_name)
			file_name = dir.get_next()
	else:	
		print("An error occurred when trying to access user data.")
