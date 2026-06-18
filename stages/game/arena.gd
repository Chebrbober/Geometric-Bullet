extends Node2D

@export var enemy: PackedScene
@onready var tile_map: TileMapLayer = $TileMapLayer

func _ready() -> void:
	NodeSpawner.node_creation_parent = self

func _exit_tree() -> void:
	NodeSpawner.node_creation_parent = null

func _on_enemy_spawn_timer_timeout() -> void:
	var terrain_cells = get_terrain_cells()
	if terrain_cells.is_empty():
		return
	
	var random_cell = terrain_cells[randi() % terrain_cells.size()]
	var world_pos = tile_map.map_to_local(random_cell)
	
	NodeSpawner.instance_node(enemy, world_pos, self)

func get_terrain_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var used_cells = tile_map.get_used_cells()
	
	for cell in used_cells:
		var terrain_data = tile_map.get_cell_tile_data(cell)
		if terrain_data and terrain_data.terrain_set == 0:
			cells.append(cell)
	
	return cells
