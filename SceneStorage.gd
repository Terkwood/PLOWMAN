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
		while file_name != "":
			if !dir.current_is_dir(): # it's a file
				file_name = dir.get_next()
				if ".tscn" in file_name:
					dir.remove(file_name)
