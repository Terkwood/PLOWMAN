extends Node

func _ready():
    deep_zindex_hack(self)

func deep_zindex_hack(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            deep_zindex_hack(N)
        else:
            if N is Sprite:
                set_zindex(N)

func set_zindex(N):
	var g = N.get_global_transform().get_origin().y + N.region_rect.size.y / 2 * N.scale.y 
	N.z_index=g
