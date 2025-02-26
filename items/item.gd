extends Node

class_name Item

var price: int
var image_path: String
var item_name: String
var description: String
var image: Texture2D
var scene: PackedScene

func on_aquire() -> void:
	pass

## Called in player _process function
## for item in PlayerState.items:
##    item.use()
func use(_delta: float) -> void:
	pass
	
