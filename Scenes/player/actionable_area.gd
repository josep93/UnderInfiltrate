extends Area2D

var actionable_items : Array[Area2D]

func action_all():
	for actionable in actionable_items:
		if !actionable.get_parent().has_method("action"): continue
		actionable.get_parent().action()

func _on_area_entered(area):
	if area in actionable_items: return
	actionable_items.append(area)


func _on_area_exited(area):
	if area not in actionable_items: return
	actionable_items.erase(area)
