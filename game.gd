extends Control

var rows = 7
var cols = 5

var flower_cell_scene = preload("res://FlowerCell.tscn")

@onready var flower_grid = get_node("FlowerGrid")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game is running!")
	for row in range(rows):
		for col in range(cols):
			var new_cell = flower_cell_scene.instantiate()
			flower_grid.add_child(new_cell)
			print("Cell added!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
