extends CanvasLayer
signal button_turned
signal generate_new_map

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MainButton_pressed():
	emit_signal("button_turned")

func _on_Generate_pressed():
	emit_signal("generate_new_map")
