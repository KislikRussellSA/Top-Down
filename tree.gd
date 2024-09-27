extends StaticBody2D

var trans = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	trans = true
	if trans:
		$Sprite2D.self_modulate.a = .4
	




func _on_area_2d_body_exited(body: Node2D) -> void:
	$Sprite2D.self_modulate.a = 1
