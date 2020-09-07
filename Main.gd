extends Node2D
export (PackedScene) var Cell

var screenSize :Vector2
#count's of column and row
var colC = 10
var rowC = 6
#chance of the live cell
var livePer = 30
# count of iterations on 10 second
var speed = 10
#iteration's time in seconds
var itTime:float = 10.0/(speed as float)
#map of the cells condition
var map
#map of the cells
var cells = []
var cell_size: int

var simulate: bool = false
var time: float = 0.0
var iteration: int = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$ColorRect.color = Color(0, 0, 0)
	$HUD/ColumnCount.text = colC as String
	$HUD/RowCount.text = rowC as String
	$HUD/LiveChanceCount.text = livePer as String
	$HUD/SpeedCount.text = speed as String
	$HUD/Iteration.text = $HUD/Iteration.text + (iteration as String)
	generate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(simulate):
		time += delta as float
		if(time >= itTime): 
			map = iterate()
			time -= itTime
			iteration += 1
			$HUD/Iteration.text = "Iteration: " + (iteration as String)
			$HUD/LiveCell.text = "Live cells: " + (draw_map() as String)

func increase_map():
	for x in colC:
		var row
		if(cells.size() <= x): row = []
		else: row = cells[x]
		if(row.size() == rowC): continue
		for y in rowC:
			if(row.size() <= y):
				var cell = Cell.instance()
				add_child(cell)
				cell.size = cell_size
				cell.set_live(map[x][y])
				row.push_back(cell)
		if(cells.size() <= x): cells.push_back(row)
		else: cells[x] = row

func decrease_map():
	var new = []
	for x in cells.size():
		if(colC <= x):
			for y in cells[0].size():
				if(cells[x][y] != null):cells[x][y].delete()
		if(cells[x].size() == rowC): new.push_back(cells[x])
		else:
			var row = []
			for y in cells[x].size():
				if(rowC <= y):cells[x][y].delete()
				else:row.push_back(cells[x][y])
			new.push_back(row)
	cells = new

func start():
	speed = $HUD/SpeedCount.text as int
	$HUD/MainButton.text = "Stop"
	itTime = 10.0/(speed as float)
	simulate = true;
	$HUD/Generate.rect_scale = Vector2(0.0, 0.0)

func iterate():
	var new = []
	for x in colC:
		var row = []
		for y in rowC:
			var neighbour_count  = aliveN(x, y)
			if(map[x][y] && (neighbour_count < 2 || neighbour_count > 3)): 
				row.push_back(false)
			elif(!map[x][y] && neighbour_count == 3):
				row.push_back(true)
			else:
				row.push_back(map[x][y])
		new.push_back(row)
	if(new == map): main_button_turn()
	return new

func generate():
	colC = $HUD/ColumnCount.text as int
	rowC = $HUD/RowCount.text as int
	livePer = $HUD/LiveChanceCount.text as int
	screenSize.x = int((get_viewport_rect().size.x - 230) - (int(get_viewport_rect().size.x -230) % colC))
	if(screenSize.x > 1650):screenSize.x = 1650
	cell_size = ((screenSize.x - 20) / colC) as int
	screenSize.y = (cell_size * rowC) + 20
	if((int(get_viewport_rect().size.y - int((get_viewport_rect().size.x as int) % rowC)) / rowC) as int < cell_size):
		screenSize.y = int(get_viewport_rect().size.y - int(get_viewport_rect().size.x as int % rowC))
		cell_size = (screenSize.y / rowC) as int
		screenSize.x = (cell_size * colC) + 20
	$ColorRect.rect_size = Vector2(screenSize.x, screenSize.y)
	iteration = 0
	fill_map()
	if(cells.size() < colC || cells[0].size() < rowC): increase_map()
	elif(cells.size() > colC || cells[0].size() > rowC): decrease_map()
	draw_map()

func fill_map():
	map = []
	for x in range(colC):
		var row = []
		for y in range(rowC):
			row.push_back(randi() % 100 < livePer)
		map.push_back(row)

func draw_map():
	var live_count = 0
	for x in range(colC):
		for y in range(rowC):
			cells[x][y].set_live(map[x][y])
			cells[x][y].size = cell_size
			cells[x][y].draw(x,y)
			if(map[x][y]):live_count += 1
	return live_count

func end():
	$HUD/MainButton.text = "Start"
	simulate = false;
	$HUD/Generate.rect_scale = Vector2(1.0, 1.0)
	pass



func aliveN(var x, var y):
	var count = 0
	for i in range(-1, 3):
		for j in range(-1, 3):
			if x+i < 0 || y+j < 0 || x+i >=colC || y+j >= rowC || (i==0 && j==0):
				continue
			elif map[x+i][y+j]:
				count+=1
	return count


func main_button_turn():
	if(!simulate):
		start()
	else:
		end()
