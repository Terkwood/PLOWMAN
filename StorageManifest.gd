extends Node

## TODO TODO TODO
## Figure out how to deal with the scene tree
## in some recursive (and accurate) fashion

## Generate a storage manifest for a given type of node
## It should return a dictionary with reasonably-formatted
## information on the position of landmarks, etc.
func generate(node: Node, path: NodePath, accum: Dictionary):
	# position-only classes
	if node.get_class() in ["HouseThatchedRoof"]:
		return { path: { "position": node.position } }
	elif node.get_class() == "ProcFencedCow":
		return {}
	
	return { path: "Nope" }