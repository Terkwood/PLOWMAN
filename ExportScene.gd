#TODO destroy
extends Node

const OUTPUT_FOLDER = "proc_packed"

func get_dir(folder):
    var new_dir = Directory.new()
    var open_dir = new_dir.open("res://"+folder+"/")
    var dirStart = new_dir.list_dir_begin()
    return new_dir
   
func check_file(file_dir):
    var d2 = Directory.new()
    return d2.file_exists(file_dir)

func export_scene(sceneTop, meshFile, fileName, exportExt):
    var packed_scene = PackedScene.new()
    print(fileName)
    var exPath = "res://"+OUTPUT_FOLDER+"/"+fileName+"."+exportExt
    print(exPath)
   
    for i in sceneTop.get_children():
        i.set_owner(sceneTop)
        if i is MeshInstance:
            sceneTop.set_name(fileName+"Body")
            i.set_name(fileName)
            i.set_mesh(ResourceLoader.load(meshFile))
        elif i.is_type("CollisionShape"):
            i.set_name(fileName+"CS")
       
    var newChild = self.get_child(0)
    print(self.get_child(0))
    print(sceneTop)
    if(!check_file(exPath)):
        packed_scene.pack(sceneTop)
        packed_scene.set_path(exPath)
        ResourceSaver.save(exPath, packed_scene)
    pass
   
# put on top-level node, exports first child and children
func save(meshFolder, outputFolder, exportExt):
    var new_dir = get_dir(meshFolder)
    var file = new_dir.get_next()
    var sceneTop = get_tree().get_current_scene().get_child(0)
    while(file!=""):
        var fullPath = "res://"+meshFolder+"/"+file
        var fileName = file.split( ".")[0]
        export_scene(sceneTop, fullPath, fileName, exportExt)
        file = new_dir.get_next()
    pass