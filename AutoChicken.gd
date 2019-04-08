extends Node2D

# all chickens share the same zone_size, since the collision
# rect is copied among them.  you could create the collision
# rect on _ready, if you wanted each chicken to have a unique
# zone size
export var zone_size: Vector2 = Vector2(128,128)

var _world_manifest = {}
func set_manifest(mfst: Dictionary):
	_world_manifest = mfst

onready var collision_rect: RectangleShape2D = $Area2D/CollisionShape2D.shape
func manifest():
	var mf = StorageManifest.position_manifest(self)
	mf["size_x"] =collision_rect.extents.x
	mf["size_y"] = collision_rect.extents.y
	return mf

func _ready():
	var mfst_entry = StorageManifest.find_entry(self, _world_manifest)
	
	if mfst_entry.empty():
		position = Vector2(randi()%Chunk.width(), randi()%Chunk.height())
		collision_rect.extents = zone_size
	else:
		position = Vector2(mfst_entry["position_x"], mfst_entry["position_y"])
		collision_rect.extents = Vector2(mfst_entry["size_x"], mfst_entry["size_y"])
