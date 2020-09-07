extends Node2D

var size :float = 40.0
var live :bool
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_live(new_live:bool):
	live = new_live;
	if live: $AnimatedSprite.animation = "live"
	else: $AnimatedSprite.animation = "die"
	
func set_size(var new_size):
	size = new_size
	
func draw(var x, var y):
	var imsize = 122.0
	var resSc = size / imsize
	self.scale = Vector2(resSc, resSc)
	self.position = Vector2((x * size) + (size / 2) + 10, (y * size) + (size / 2) + 10)

func delete():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
