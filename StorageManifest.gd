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

## Generate a storage manifest for a given type of node
## It should return a dictionary with reasonably-formatted
## information on the position of landmarks, etc.
static func generate(node: Node, accum: Dictionary = {}):
	var path = node.get_path()

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