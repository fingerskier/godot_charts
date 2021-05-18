extends Control

export var Maximum_Data_Size = 100
export var X_Axis_Offset = 50
export var Y_Axis_Offset = 50

var data_points = []
var viewport_height = 600
var viewport_width = 1024

onready var Highlight = $Highlight
onready var HighlightLabel = $Highlight/Label
onready var Line = $Line2D
onready var Xaxis = $X_Axis
onready var Yaxis = $Y_Axis
onready var Xlabel = $X_Label
onready var Ylabel = $Y_Label


func _ready():
	Xaxis.points[0].x = 0
	Xaxis.points[0].y = viewport_height-X_Axis_Offset
	Xaxis.points[1].x = viewport_width
	Xaxis.points[1].y = viewport_height-X_Axis_Offset
	
	Yaxis.points[0].x = Y_Axis_Offset
	Yaxis.points[0].y = 0
	Yaxis.points[1].x = Y_Axis_Offset
	Yaxis.points[1].y = viewport_height


func _draw():
	for point in data_points:
		Line.add_point(point)
		
		
func _input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.pressed and (event.button_index == BUTTON_LEFT):
			var cursor_position:Vector2 = get_global_mouse_position()
			var closest_distance = 1000000
			var closest_index = -7
			
			for I in range(Line.points.size()-1):
				var P1 = Line.points[I]
				var P2 = Line.points[I+1]
				var closest_point = Geometry.get_closest_point_to_segment_2d(cursor_position, P1, P2)
				var this_distance = closest_point.distance_squared_to(cursor_position)
				
				if this_distance < closest_distance:
					closest_distance = this_distance
					closest_index = I
			
			print('closest index %s' % closest_index)
			var clicked_point = Line.points[closest_index]
			Highlight.set_global_position(clicked_point)
			Highlight.visible = true
			HighlightLabel.text = 'clicked point %s' % closest_index


func _Vector2(x:int, y:int):
	var new_x = x + Y_Axis_Offset
	var flipped_y = viewport_height - y - X_Axis_Offset
	return Vector2(new_x, flipped_y)


func push(point:Vector2):
	Line.add_point(_Vector2(point.x, point.y))
	
	if data_points.size() > Maximum_Data_Size:
		Line.remove_point(0)
