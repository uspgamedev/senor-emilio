
extends "res://scripts/classes/prop.gd"

export(NodePath)var stored

func is_full():
  return stored != null

func store(item):
  if is_full():
    return
  printt(get_name(), "storing item")
  stored = item
  item.hide()

func remove():
  if !is_full():
    return
  printt(get_name(), "removing item")
  stored.show()
  stored = null

func get_item():
  return stored

func interact(body):
  if body.grabbing:
    var drop = body.get_pocket_item()
    body.connect("drop", self, "store", [], CONNECT_ONESHOT)
    body.drop()
    printt(get_name(), "requesting drop")
  elif is_full():
    var item = get_item()
    item.set_layer_mask(body.get_layer_mask())
    body.grab(item)
    remove()
    printt(get_name(), "requesting grab")
