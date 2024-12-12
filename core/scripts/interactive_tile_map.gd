extends TileMap

@export var interactables_layer = 0

var interactable_tiles = {
	Vector2i(3, 0): preload("res://scenes/spaghetti_tile.tscn"),
	Vector2i(1, 0): preload("res://scenes/weeds_tile.tscn")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	var tiles = get_used_cells(interactables_layer)
	
	for tile in tiles:
		var scene_to_load = interactable_tiles.get(get_cell_atlas_coords(interactables_layer, tile))
		if scene_to_load:
			erase_cell(interactables_layer, tile)
			var scene = scene_to_load.instantiate()
			scene.position = map_to_local(tile)
			add_child(scene)
			
