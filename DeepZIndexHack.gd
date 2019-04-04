extends Node

func _ready():
	deep_zindex_hack(self)

func deep_zindex_hack(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            deep_zindex_hack(N)
        else:
            if N is Sprite:
                ZIndex.hack(N)
