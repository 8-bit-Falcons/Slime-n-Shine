extends TileMap

@export var interactables_layer = 0

var interactable_tiles = {
	Vector2i(3, 0): "test"
}




# Called when the node enters the scene tree for the first time.
func _ready():
	var tiles = get_used_cells(interactables_layer)
	
	for tile in tiles:
		var scene_to_load = interactable_tiles.get(get_cell_atlas_coords(interactables_layer, tile))
		if scene_to_load:
			erase_cell(interactables_layer, tile)
