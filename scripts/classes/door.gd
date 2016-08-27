extends StaticBody2D

onready var closed = get_node("closed")
onready var opened = get_node("opened")

func on():
  print("door open")
  opened.show()
  closed.hide()
  

func off():
  print("door closed")
  opened.hide()
  closed.show()