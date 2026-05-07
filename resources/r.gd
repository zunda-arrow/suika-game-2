extends Node

func load_folder(folder: String) -> Variant:
	var out = {}
	var files = []
	for f in ResourceLoader.list_directory(folder):
		ResourceLoader.load_threaded_request(folder + "/" + f)
		files.push_back(f)
		
	for f in files:
		var h = ResourceLoader.load_threaded_get(folder + "/" + f)
		out[f.trim_suffix(".tres")] = h
	
	return out

var Pets = load_folder("res://resources/pets") as Dictionary[String, PetResource]
var Fruits = load_folder("res://resources/fruits") as Dictionary[String, FruitResouce]
