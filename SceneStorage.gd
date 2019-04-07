extends Node

const OUTPUT_FOLDER = "proc_packed"

func _ready():
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir(OUTPUT_FOLDER)
	dir.close()

func save_scene(node: Node, name: String):
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	var file = "user://%s.tscn" % name
	ResourceSaver.save(file, packed_scene)
	
func load_scene(file_name: String):
	var packed_scene = load("user://%s.tscn" % file_name)
	var i = packed_scene.instance()
	print("loaded %s " % file_name)
	return i