
extends Control


func _ready():
	update()
	pass

func _draw():
	draw_line(Vector2(0,60),Vector2(120,60),Color(0.5,0.5,0.5),2)
	draw_line(Vector2(0,60),Vector2(60,0),Color(0.5,0.5,0.5),2)
	draw_line(Vector2(60,0),Vector2(120,60),Color(0.5,0.5,0.5),2)
	for i in range(20):
		draw_line(Vector2(10+i*5,55),Vector2(10+i*5,60),Color(0,0,0),2)
	for i in range(37):
		var outerpoint=Vector2(cos(PI*i/36)*60,sin(PI*i/36)*60)
		outerpoint.y=60-outerpoint.y
		outerpoint.y-=60
		outerpoint=outerpoint.normalized()
		if(i<=18):
			outerpoint*=60/(sin(PI*i/36)+cos(PI*i/36))
		else:
			outerpoint*=60/(sin(PI*i/36)-cos(PI*i/36))
		#if(i>17):
		#	outerpoint.x*=-1
		outerpoint.x+=60
		outerpoint.y+=60
		if(i!=9 and i!=27 and i!=18):
			draw_line(Vector2(60+cos(PI*i/36)*20,60-sin(PI*i/36)*20),outerpoint,Color(0,0,0,0.5),2)
		else:
			draw_line(Vector2(60+cos(PI*i/36)*15,60-sin(PI*i/36)*15),outerpoint,Color(0,0,0,0.5),2)
