extends StaticBody2D

onready var closed = get_node("closed")
onready var opened = get_node("opened")

export(int) var target_stage = 0
export(String) var target_door = "door"

signal change_stage(which, door)

func on():
  print("door open")
  opened.show()
  closed.hide()


func off():
  print("door closed")
  opened.hide()
  closed.show()

func interact(body):
  #emit_signal("change_stage", target_stage,  target_door)
  get_node("/root/main/gameplay")._change_stage(target_stage, target_door)
  printt(get_name(), "door used!")
