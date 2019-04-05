extends Node

const OUTPUT_FOLDER = "proc_packed"

func save(node: Node, name: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var file = "res://%s/%s.tscn" % [OUTPUT_FOLDER,name]
	ResourceSaver.save(file, packed_scene)
	return file