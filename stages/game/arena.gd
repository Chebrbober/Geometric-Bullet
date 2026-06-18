extends Node2D

@onready var tile_map: TileMapLayer = $TileMapLayer
@onready var wave_manager: WaveManager = $WaveManager

func _ready() -> void:
	Global.node_creation_parent = self

func _exit_tree() -> void:
	Global.node_creation_parent = null

func _on_wave_started(wave_number: int) -> void:
	print("Wave %d started!" % wave_number)

func _on_wave_completed(wave_number: int) -> void:
	print("Wave %d completed! Get ready for wave %d" % [wave_number, wave_number + 1])

func spawn_enemy_at_random_terrain(enemy_instance: PackedScene) -> void:
	var terrain_cells = get_terrain_cells()
	if terrain_cells.is_empty():
		return
	
	var random_cell = terrain_cells[randi_range(0, terrain_cells.size() - 1)]
	var world_pos = tile_map.map_to_local(random_cell)
	
	Global.instance_node(enemy_instance, world_pos, self)

func get_terrain_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var used_cells = tile_map.get_used_cells()
	
	for cell in used_cells:
		var terrain_data = tile_map.get_cell_tile_data(cell)
		if terrain_data and terrain_data.terrain_set == 0:
			cells.append(cell)
	
	return cells