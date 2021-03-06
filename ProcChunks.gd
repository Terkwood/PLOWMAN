extends Node2D

const AutoChunk = preload("res://AutoChunk.tscn")
const SceneStorage = preload("res://SceneStorage.gd")
const DeepZIndexHack = preload("res://DeepZIndexHack.gd")

var active_chunks = {}
var stored_chunks = {}
var chunk_manifests = {}

onready var storage = SceneStorage.new()

func create_chunk(chunk_id):
	var c = AutoChunk.instance()
	c.init(chunk_id)
	active_chunks[chunk_id] = {
		"chunk": c,
		"storage_name": c.storage_name()
	}
	call_deferred("add_child", c)
	return c

func _ready():
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var chunk_id = Vector2(x,y)
			create_chunk(chunk_id)

func _on_player_entered_chunk(chunk_id: Vector2):
	print("player entered chunk %s" % chunk_id)
	for i in active_chunks:
		if (
			i.x < chunk_id.x - 1 || i.x > chunk_id.x + 1 ||
			i.y < chunk_id.y - 1 || i.y > chunk_id.y + 1
		):
			var cr = active_chunks[i]
			if !_pend_save.has(i):
				_pend_save[i] = cr
				call_deferred("save_chunk", cr, i)

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
			var is_chunk_active = active_chunks.has(cid_a)
			var is_chunk_stored = stored_chunks.has(cid_a)
			if !is_chunk_active && is_chunk_stored:
				var file = stored_chunks[cid_a]
				# cannot create area2d when another area2d is undergoing
				# physics processing.  this will defer the execution
				# until "idle time"
				if !_pend_restore.has(cid_a):
					_pend_restore[cid_a] = file
					call_deferred("restore_chunk", file, cid_a)
			if !is_chunk_active && !is_chunk_stored:
				create_chunk(cid_a)

# dict prevents multiple calls at the same time
var _pend_save = {}
func save_chunk(cr, chunk_id: Vector2):
	var chunk = cr.chunk
	var cmf = StorageManifest.generate(chunk)
	storage.save_scene(chunk, cr["storage_name"])
	remove_child(chunk)
	chunk.queue_free()
	active_chunks.erase(chunk_id)
	stored_chunks[chunk_id] = cr["storage_name"]
	chunk_manifests[chunk_id] = cmf
	_pend_save.erase(chunk_id)
	ProcZoneRepo.erase_chunk(chunk_id)

# It's important to pass this flag so that we can easily
# match the paths generated in the storage manifest.
# If we don't pass it, `storage.load_scene` will continue
# to add '@' characters onto the front of the instance name.
const _RESTORE_WITH_LEGIBLE_NAMES = true

# dict prevents multiple calls at the same time
var _pend_restore = {}
func restore_chunk(file: String, chunk_id: Vector2):
	var chunk = storage.load_scene(file)
	chunk.chunk_id = chunk_id
	chunk._storage_name = file

	if chunk_manifests.has(chunk_id):
		deep_set_manifests(chunk, chunk_manifests[chunk_id])

	add_child(chunk, _RESTORE_WITH_LEGIBLE_NAMES)
	chunk.set_owner(get_parent()) # set owner so that resource saving works
	ZIndex.deep_hack(chunk)
	stored_chunks.erase(file)
	active_chunks[chunk_id] = {"chunk":chunk,"storage_name":file}
	_pend_restore.erase(chunk_id)

const SET_MANIFEST_METHOD = "set_manifest"
func deep_set_manifests(node, mnfst: Dictionary):
	if node.has_method(SET_MANIFEST_METHOD):
		node.call(SET_MANIFEST_METHOD, mnfst)
	for child in node.get_children():
		deep_set_manifests(child, mnfst)

