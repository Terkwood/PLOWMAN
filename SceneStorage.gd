extends Node

const OUTPUT_FOLDER = "proc_packed"

func save_scene(node: Node, name: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var file = "res://%s/%s.tscn" % [OUTPUT_FOLDER,name]
	ResourceSaver.save(file, packed_scene)
	return name

# make sure to set the owner of the child nodes (otherwise the children won't be saved)
func load_scene(file_name: String, parent: Node):
	# Load the PackedScene resource
	var packed_scene = load("res://%s/%s.tscn" % [OUTPUT_FOLDER,file_name])
	var i = packed_scene.instance()
	add_child(i)
	i.set_owner(parent)