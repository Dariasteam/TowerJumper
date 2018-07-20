extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func set_number(n):
	get_node("LabelPoints").set_text(n)

func _ready():
	pass


func _on_Timer_timeout():
	queue_free()
