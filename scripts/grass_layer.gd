
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

	# TODO:
	# 1. Convert the world position into local coordinates.
	# 2. Convert the local coordinates into a grid cell.
	# 3. Return the grid cell.
	#
	# Use:
	# - to_local()
	# - local_to_map()

	return Vector2i.ZERO


# Returns the world position at the center of a tile.
# Used to position flowers correctly on the grid.
func cell_to_world_position(cell: Vector2i) -> Vector2:

	# TODO:
	# 1. Convert the grid cell into local coordinates.
	# 2. Convert the local coordinates into world coordinates.
	# 3. Return the world position.
	#
	# Use:
	# - map_to_local()
	# - to_global()
	#
	# map_to_local() returns the center of the cell.

	return Vector2.ZERO


# ==================================================
# PLAYABLE GRID
# ==================================================

# Checks whether a cell belongs to the playable
# grass area of the board.
func is_valid_cell(cell: Vector2i) -> bool:

	# TODO:
	# 1. Check whether a grass tile exists at this cell.
	# 2. Make sure the tile belongs to the playable area.
	# 3. Return true if the cell is playable.
	#
	# Use get_cell_source_id().
	#
	# An empty tile normally has source ID -1.

	return false


# Returns the dimensions of the playable grid.
# Example: Vector2i(5, 5) for a 5x5 board.
func get_grid_size() -> Vector2i:

	# TODO:
	# 1. Determine the width of the playable grid.
	# 2. Determine the height of the playable grid.
	# 3. Return both values as a Vector2i.
	#
	# Use get_used_rect() for the tile bounds.
	#
	# Exclude non-playable decorative tiles
	# when determining the playable grid size.

	return Vector2i.ZERO


# ==================================================
# VALID CELL SELECTION
# ==================================================

# Returns every playable cell on the grass layer.
# Used for finding spawning positions and
# determining the playable board area.
func get_valid_cells() -> Array[Vector2i]:

	# TODO:
	# 1. Create an array to store valid cells.
	# 2. Get the cells used by the grass layer.
	# 3. Loop through those cells.
	# 4. Check each cell using is_valid_cell().
	# 5. Add valid cells to the array.
	# 6. Return the completed array.
	#
	# Use:
	# - get_used_cells()
	# - is_valid_cell()
	#
	# Do not check whether flowers occupy these cells.
	# GameBoard handles flower occupancy.

	return []


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
