extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		print("Keyboard pressed!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cell_button_pressed() -> void:
	print("Flower cell clicked!")
