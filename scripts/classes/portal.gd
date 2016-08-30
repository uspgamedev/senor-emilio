
extends "res://scripts/classes/prop.gd"

export(NodePath) var portal_link = null

onready var preview = get_node("preview")

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
  preview.set_texture(item.get_texture())
  preview.set_region(true)
  preview.set_region_rect(Rect2(0, 0, 32, 32))
  preview.set_pos(preview.get_pos() + Vector2(0, -10))
  preview.show()
  item.hide()
  get_portal_link().store(item)

func remove():
  if !is_full():
    return
  printt(get_name(), "removing item")
  stored.show()
  stored = null
  preview.hide()
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
