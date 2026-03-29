extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

@export var stone_count: int = 2
@export var stone_offset: Vector2 = Vector2(-3.0, -7.0)

@export var stone_scene: PackedScene = preload("res://scenes/objects/rocks/stone.tscn")

func _ready() -> void:
	hurt_component.on_hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)


func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	
	material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)


func on_max_damage_reached() -> void:
	call_deferred("spawn_stones")
	print("Max damage reached")
	queue_free()
	
func spawn_stones() -> void:
	for i in stone_count:
		var stone_instance = stone_scene.instantiate() as Node2D
		stone_instance.global_position = global_position + (stone_offset * i)
		get_parent().add_child(stone_instance)
