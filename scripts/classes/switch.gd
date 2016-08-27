extends StaticBody2D

export(NodePath) var device = null

onready var on = get_node("On")
onready var off = get_node("Off")

func on():
  if on.is_hidden():
    return false
  return true

func _get_device():
  return get_node(device)

func turn_on_off():
  printt("turn")
  if on():
    off.show()
    on.hide()
    _get_device().off()
  else:
    off.hide()
    on.show()
    _get_device().on()



func _on_range_enter( body ):
  printt("enter body=", body)
  body.connect("interact", self, "turn_on_off")

func _on_range_exit( body ):
  printt("exit body=", body)
  body.disconnect("interact", self, "turn_on_off")
