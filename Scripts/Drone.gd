extends PathFollow2D

export var speed = 160
export var hp = 10

var type

func init(drone_type):
	type = drone_type
	speed = Settings.tower_mob_stats[type]["speed"]
	hp = Settings.tower_mob_stats[type]["hp"]
	if type == "big":
		$Area2D/DroneGreen.visible = true
	elif type == "fast":
		$Area2D/DroneOrange.visible = true
	elif type == "normal":
		$Area2D/DroneGray.visible = true


func _ready():
	$Label.text = str(hp)


func _physics_process(delta):
	if(Settings.paused == false):
		offset += speed * delta
		if unit_offset >= 1:
			reached_end()


func reached_end():
	queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("shot"):
		area.queue_free()
		hp -= 1
		$Label.text = str(hp)
		if hp == 0:
			if area.owner_tower:
				area.owner_tower.updateDronesDestroyed()
			Settings.drones_destroyed += 1
			if type == "big":
				get_parent().get_parent().get_parent().get_parent().drone_destroyed(5)
			elif type == "fast":
				get_parent().get_parent().get_parent().get_parent().drone_destroyed(2)
			elif type == "normal":
				get_parent().get_parent().get_parent().get_parent().drone_destroyed(1)
			queue_free()
	if area.is_in_group("Base"):
		Settings.drones_destroyed += 1
		get_parent().get_parent().get_parent().get_parent().base_hit()
		queue_free()
