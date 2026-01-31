extends StaticBody3D
class_name Damageable

@export var health : float = 2

func damage(incoming_damage:float):
	health -= incoming_damage
	if health <= 0:
		death()
	else:
		playDamageFeedback()
func death():
	queue_free()

func playDamageFeedback():
	pass
