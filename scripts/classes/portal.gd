extends StaticBody2D

export(NodePath) var portal_link = null

onready var storage = get_node("Storage")

func get_portal_link():
  return get_node(portal_link)

func is_full():
  if storage.get_child_count() > 0:
    return true
  return false

func store(item):
  if is_full():
    return
  storage.add_child(item)
  yield(get_tree(), "fixed_frame")
  get_portal_link().store(item)

func remove():
  var item = get_item()
  if item == null:
    return
  storage.remove_child(item)
  yield(get_tree(), "fixed_frame")
  get_portal_link().remove(item)

func get_item():
  if not is_full():
    return null
  return storage.get_child(0)
