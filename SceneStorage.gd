extends Node

const OUTPUT_FOLDER = "proc_packed"

func save(node: Node, name: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	ResourceSaver.save("res://%s/%s.tscn" % [OUTPUT_FOLDER,name], packed_scene)