extends Control

var x = 0

onready var Chart = $LineChart


func _ready():
	Chart.Xlabel.text = 'Time (t)'
	Chart.Ylabel.text = 'Size (m)'


func _on_Timer_timeout():
	var y = rand_range(0, 500)
	
	Chart.push(Vector2(x,y))
	
	x += 10
