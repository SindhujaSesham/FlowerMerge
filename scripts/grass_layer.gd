
extends TileMapLayer

# ==================================================
# GRASS LAYER
# ==================================================
# Manages the playable grid and tile coordinates.
# Converts between world positions and grid cells.
# Provides valid cells for flower placement.
#
# Flower occupancy and merging are handled
# by GameBoard.gd.
# ==================================================


# ==================================================
# GRID POSITION CONVERSIONS
# ==================================================

# Converts a world position into a grid cell.
# Used when a flower is dropped onto the board.
func world_position_to_cell(world_position: Vector2) -> Vector2i:
	var local_position = to_local(world_position)
	var cell = local_to_map(local_position)
	return cell

# Returns the world position at the center of a tile.
# Used to position flowers correctly on the grid.
func cell_to_world_position(cell: Vector2i) -> Vector2:
	var local_position = map_to_local(cell)
	var world_position = to_global(local_position)

	return world_position

# ==================================================
# PLAYABLE GRID
# ==================================================

# Checks whether a cell belongs to the playable
# grass area of the board.
func is_valid_cell(cell: Vector2i) -> bool:
	var source_id = get_cell_source_id(cell)
	return source_id != -1

# Returns the dimensions of the playable grid.
# Example: Vector2i(5, 5) for a 5x5 board.
func get_grid_size() -> Vector2i:
	var used_rect = get_used_rect()
	var width = used_rect.size.x
	var height = used_rect.size.y

	return Vector2i(width, height)

# ==================================================
# VALID CELL SELECTION
# ==================================================

# Returns every playable cell on the grass layer.
# Used for finding spawning positions and
# determining the playable board area.
func get_valid_cells() -> Array[Vector2i]:
	var valid_cells: Array[Vector2i] = []
	var used_cells = get_used_cells()
	
	for cell in used_cells:
		if is_valid_cell(cell):
			valid_cells.append(cell)

	return valid_cells

# Returns a random playable cell from the grass layer.
# Used when generating new flower positions.
func get_random_valid_cell():

	# TODO:
	# 1. Get all playable cells using get_valid_cells().
	# 2. Check whether the array contains any cells.
	# 3. Select a random cell from the array.
	# 4. Return that cell.
	# 5. Return null if no playable cells exist.
	#
	# Use Array.pick_random().
	#
	# GameBoard checks whether the selected
	# cell is occupied before spawning a flower.

	return null
