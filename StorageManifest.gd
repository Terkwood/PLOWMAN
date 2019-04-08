extends Node

func merge_dir(target, patch):
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge_dir(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
		    target[key] = patch[key]

const PATH_MATCH = "*AutoChunk*"
func trim_path(p: NodePath):
	var idx = 0
	var nc = p.get_name_count()
	for x in range(nc):
		if p.get_name(x).match (PATH_MATCH):
			idx = x
	var trimmed = "./"
	var lim = nc - idx
	for y in range(lim):
		trimmed += p.get_name(y + idx)
		if y != lim - 1:
			trimmed += "/"
	return NodePath(trimmed)

## Generate a storage manifest for a given type of node
## It should return a dictionary with reasonably-formatted
## information on the position of landmarks, etc.
func generate(node: Node, accum: Dictionary = {}):
	var path = trim_path(node.get_path())

	if node.has_method("manifest"):
		accum[path] = node.call("manifest")
	
	for c in node.get_children():
		var child_accum = generate(c, accum)
		merge_dir(accum, child_accum)
	
	return accum

func position_manifest(node: Node):
	return { "position_x": node.position.x, "position_y": node.position.y }

func size_position_manifest(node):
	return {
			"size_x": node.size.x,
			"size_y": node.size.y,
			"position_x": node.position.x,
			"position_y": node.position.y,
		}

func find_entry(node: Node, manifst: Dictionary) -> Dictionary:
	var node_path = trim_path(node.get_path())
	var found: Dictionary = {}
	for k in manifst.keys():
		if k == node_path:
			found = manifst[k]
			break
	return found

const NO_ZONE = Rect2(0,0,0,0)
func find_zone(node, mfst: Dictionary, default: Rect2 = Rect2(0,0,0,0)) -> Rect2:
	var entry = StorageManifest.find_entry(node, mfst)
	return Rect2(
			Vector2(entry.get("position_x",default.position.x),
					entry.get("position_y",default.position.y)),
			Vector2(entry.get("size_x",default.size.x),
				    entry.get("size_y",default.size.y)))
