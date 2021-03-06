extends Node2D

### CAUTION!
### This node needs to execute before the other procgen
### nodes, as it is blissfully unaware of ProcZoneRepo's
### capability of assigning it a suitable position in the
### world.
### See https://github.com/Terkwood/PLOWMAN/issues/35

# adapted with inspiration from http://kidscancode.org/blog/2018/08/godot3_procgen1/
const min_width  =  5   # in tiles
const max_width  = 12   # in tiles
const min_height =  5   # in tiles
const max_height = 12   # in tiles
var max_offset_x = Chunk.num_tiles_x - min_width  # in tiles
var max_offset_y = Chunk.num_tiles_y - min_height # in tiles

const NW = 6
const NE = 8
const SW = 12
const SE = 14
const HORIZONTAL = 1
const VERTICAL = 4

# get a reference to the map for convenience
onready var Map = $TileMap
onready var Set = Map.tile_set
onready var Cow = $Animals/Cow

onready var AutoFence = preload("res://AutoFence.tscn")

func pixel_bounding_box(tile_offset_x,tile_offset_y,num_tiles_x,num_tiles_y):
	return Rect2(
		Vector2(tile_offset_x * Chunk.TILE_SIZE, tile_offset_y * Chunk.TILE_SIZE),
		Vector2(num_tiles_x * Chunk.TILE_SIZE, num_tiles_y * Chunk.TILE_SIZE))

func gen_fence_tiles():
	var tile_offset_x = int(max(0, randi()%max_offset_x - min_width))
	var tile_offset_y = int(max(0, randi()%max_offset_y - min_width))
	
	# in tiles
	var num_tiles_x = int(min(Chunk.num_tiles_x - tile_offset_x, min_width + randi()%max_width))
	var num_tiles_y = int(min(Chunk.num_tiles_y - tile_offset_y, min_height + randi()%max_height))
	
	return {"tile_offset_x": tile_offset_x, "tile_offset_y":tile_offset_y, "num_tiles_x":num_tiles_x, "num_tiles_y":num_tiles_y}
	
func place_cow(tile_offset_x, tile_offset_y, width, height):
	Cow.position.x = (tile_offset_x + 2 + randi()%(int(max(1,width-3)))) * Chunk.TILE_SIZE
	Cow.position.y = (tile_offset_y + 1 + randi()%(height-2)) * Chunk.TILE_SIZE
	
func animate_cow():
	var available_anims = $Animals/Cow/Sprite/AnimationPlayer.get_animation_list()
	$Animals/Cow/Sprite/AnimationPlayer.play(available_anims[randi()%available_anims.size()])

func make_fence(bb):
	var fence = AutoFence.instance()
	fence.init(bb.size)
	fence.position = bb.position
	add_child(fence)

var _manifest = {}
func manifest():
	return _manifest
func set_manifest(mfst: Dictionary):
	self._manifest = mfst

func _ready():
	var fc = {}
	var bb = Rect2(0,0,0,0)
	var force_proc_zone = false
	var man_entry = StorageManifest.find_entry(self, _manifest)
	if !man_entry.empty():
		fc = man_entry
		bb = Rect2(man_entry["position_x"], man_entry["position_y"], man_entry["size_x"], man_entry["size_y"])
		force_proc_zone = true
	else:
		fc = gen_fence_tiles()
		bb = pixel_bounding_box(fc["tile_offset_x"], fc["tile_offset_y"], fc["num_tiles_x"], fc["num_tiles_y"])
	
	place_cow(fc["tile_offset_x"], fc["tile_offset_y"], fc["num_tiles_x"], fc["num_tiles_y"])
	animate_cow()
	make_fence(bb)
	if force_proc_zone:
		ProcZoneRepo.force_assign_zone(bb, Chunk.id(self))
	else:
		ProcZoneRepo.try_add_proc_zone(bb, Chunk.id(self))

	_manifest = fc.duplicate()
	var bbmf = StorageManifest.size_position_manifest(bb)
	for k in bbmf:
		_manifest[k] = bbmf[k]

