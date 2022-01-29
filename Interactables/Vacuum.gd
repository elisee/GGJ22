extends BaseInteractable

func can_interact():
	return get_node("/root/Spatial/Player").get_item() == "Battery"

func interact():
	.interact()
	
	var light = get_node("Vacuum_Light") as MeshInstance
	var mat = light.get_active_material(1) as SpatialMaterial
	mat.set_albedo(Color(0, 1, 0))
	
	get_node("Battery").visible = true
	
	get_node("/root/Spatial/Player").increment_progress()
