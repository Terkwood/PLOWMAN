extends Node2D

export var size = Vector2(3,3)

const AutoChunk = preload("res://AutoChunk.gd")
const SceneStorage = preload("res://SceneStorage.gd")

var active_chunks = {}
var stored_chunks = {}

onready var storage = SceneStorage.new()

func _ready():
	for x in range(size.x):
		for y in range(size.y):
			var i = Vector2(x,y)
			var c: AutoChunk = AutoChunk.new(i)
			active_chunks[i] = {
				"chunk": c,
				"storage_name": c.storage_name()
			}
			add_child(c)

func _on_player_entered_chunk(chunk_id: Vector2):
	print("player entered chunk %s" % chunk_id)
	$ChunkLabel.set_text("%s" % chunk_id)
	#print("active chunks: %s" % str(active_chunks.keys()))
	var to_erase = []
	for i in active_chunks:
		if (
			i.x < chunk_id.x - 1 || i.x > chunk_id.x + 1 ||
			i.y < chunk_id.y - 1 || i.y > chunk_id.y + 1
		):
			var cr = active_chunks[i]
			var chunk = cr.chunk
			storage.save_scene(chunk, cr["storage_name"])
			remove_child(chunk)
			to_erase.push_front(i)
			stored_chunks[i] = cr["storage_name"]
			print("saved to disk: %s" % cr["storage_name"])

		var adjacents = [
			Vector2(1,0),
			Vector2(-1,0),
			Vector2(0,1),
			Vector2(0,-1),
			Vector2(-1,-1),
			Vector2(-1,1),
			Vector2(1,-1),
			Vector2(1,1)
		]

		for a in adjacents:
			var cid_a = chunk_id + a
			if !active_chunks.has(cid_a) && stored_chunks.has(cid_a):
				var file = stored_chunks[cid_a]
				var chunk = storage.load_scene(file)
				add_child(chunk)
				chunk.set_owner(get_parent()) # set owner so that resource saving works
				stored_chunks.erase(file)
				active_chunks[cid_a] = {"chunk":chunk,"storage_name":file}

	for e in to_erase:
		active_chunks.erase(e)	