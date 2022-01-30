extends BaseInteractable

var point_index = 0
var speed = 3
var active = false

onready var vacuum_path = get_tree().get_nodes_in_group("vacuum_path")[0] as Path

func can_interact():
	return player.get_item() == "Battery"

func interact():
	.interact()
	
	var light = $Vacuum_Light
	var mat = light.get_active_material(1) as SpatialMaterial
	mat.set_albedo(Color(0, 1, 0))
	mat.set_emission(Color(0, 1, 0))
	
	$Battery.visible = true
	$SoundPlayerUIBatteryInsert.play()
	$SoundPlayerVacuumMoving.play()
	$SoundPlayerVacuumVO.play()
	$SoundPlayerUISuccess.play()

	self.active = true

func _physics_process(delta):
	if not self.active:
		return
	
	var pos = vacuum_path.curve.get_point_position(point_index)
	var dist = pos.distance_to(self.translation)
	if dist < 0.01:
		self.translation = pos
		
		var next_point_index = self.point_index + 1
		if next_point_index >= vacuum_path.curve.get_point_count():
			next_point_index = 0
		
		var next_pos = vacuum_path.curve.get_point_position(next_point_index)
		var angle = atan2(next_pos.x - pos.x, next_pos.z - pos.z)
		var angle_dist = short_angle_dist(self.rotation.y, angle)

		if abs(angle_dist) < PI / 180:
			self.rotation.y = angle
			self.point_index = next_point_index
		else:
			self.rotation.y += sign(angle_dist) * min(delta, abs(angle_dist))
	else:
		var dir = (pos - self.translation) / dist
		self.translation += dir * min(speed * delta, dist)
	

func short_angle_dist(from, to):
	var max_angle = TAU
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
