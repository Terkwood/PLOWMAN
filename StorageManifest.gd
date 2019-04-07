extends Node

static func merge_dir(target, patch):
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
static func trim_path(p: NodePath):
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
static func generate(node: Node, accum: Dictionary = {}):
	var path = trim_path(node.get_path())

	if node.has_method("manifest"):
		accum[path] = node.call("manifest")
	
	for c in node.get_children():
		var child_accum = generate(c, accum)
		merge_dir(accum, child_accum)
	
	return accum

static func position_manifest(node: Node):
	return { "position": node.position }

static func size_position_manifest(node: Node):
	return {
			"size": node.size,
			"position": node.position
		}