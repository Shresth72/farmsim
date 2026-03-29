class_name TreeBase
extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

@export var log_count: int = 2
@export var log_offset: float = 5.0

@export var log_scene: PackedScene = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.on_hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	

func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	
	material.set_shader_parameter("shake_intensity", 1.0)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

	
func on_max_damage_reached() -> void:
	call_deferred("spawn_logs")
	print("Max damage reached")
	queue_free()
	
func spawn_logs() -> void:
	for i in log_count:
		var log_instance = log_scene.instantiate() as Node2D
		log_instance.global_position = global_position + Vector2(0, i * log_offset)
		get_parent().add_child(log_instance)
