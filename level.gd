extends Node2D

var player = preload("player.tscn")
var p = player.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(p)
	p.health_changed.connect($UI/Health.update_simple)
	p.position.x = 150
	p.position.y = 150
	p.stop.connect(end)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end():
	$UI/GameOver.visible = true
