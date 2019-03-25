extends Node

func _ready():
    deep_ysort_everything(self)

func deep_ysort_everything(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            deep_ysort_everything(N)
        else:
            if N is Sprite:
                setZOrder(N)
                #print("- "+N.get_path())

func _process(_delta):
	deep_ysort_everything(self)

func setZOrder(N):
	var myPos = N.position
	var mySize = N.get_texture().get_height()
	var bottomOfSprite= (mySize*N.get_scale().y)/2
	print("bottom of sprite " + str(bottomOfSprite))	 
	N.z_index=(myPos.y+bottomOfSprite)