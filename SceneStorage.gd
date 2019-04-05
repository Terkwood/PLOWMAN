extends Node

const OUTPUT_FOLDER = "proc_packed"

func save_scene(node: Node, name: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var file = "res://%s/%s.tscn" % [OUTPUT_FOLDER,name]
	ResourceSaver.save(file, packed_scene)
	print("saved %s " % file)

# make sure to set the owner of the child nodes (otherwise the children won't be saved)
func load_scene(file_name: String):
	var packed_scene = load("res://%s/%s.tscn" % [OUTPUT_FOLDER,file_name])
	var i = packed_scene.instance()
	print("loaded %s " % file_name)
	return i