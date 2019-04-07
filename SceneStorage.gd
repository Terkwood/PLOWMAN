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