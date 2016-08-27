
extends "res://scripts/classes/prop.gd"

export(NodePath) var portal_link = null

var stored = null

func get_portal_link():
  return get_node(portal_link)

func is_full():
  return stored != null

func store(item):
  if is_full():
    return
  printt(get_name(), "storing item")
  stored = item
  item.hide()
  get_portal_link().store(item)

func remove():
  if !is_full():
    return
  printt(get_name(), "removing item")
  stored.show()
  stored = null
  get_portal_link().remove()

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
