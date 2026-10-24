extends Node2D
## Briarwake rewards retain campaign totals and stable encounter keys across retries.
var game: Node
var points := 0
var earned: Dictionary = {}
var motes: Array[Dictionary] = []
var chest_available := false
var chest_opened := false
var opening := 0.0
var chest_phase := "closed"
var animation_time := 0.0
var reveal_progress := 0.0
var effect_time := 0.0
var reduced_effects := false
const OPEN_DURATION := 3.8
const CHEST_FOOT := Vector2(6570,620)
const Ornate = preload("res://scripts/ui/ornate_skin.gd")
const REWARD_ICON = preload("res://assets/runtime/shared/ui/UI-003_crystal.png")
var starting_points := 0
var starting_attack_damage := 1
var watched_enemies: Dictionary = {}
var serif: SystemFont
var chest_textures: Array[Texture2D] = []
var score_label: Label
func _ready() -> void:
	var progress: Variant = game.get_tree().get_meta("campaign_progress",{})
	if progress is Dictionary:
		starting_points = maxi(0,int(progress.get("points",0)))
		starting_attack_damage = clampi(int(progress.get("attack_damage",game.player.attack_damage)),1,3)
	points = starting_points
	game.player.attack_damage = starting_attack_damage
	serif = SystemFont.new()
	serif.font_names = PackedStringArray(["Georgia","Noto Serif","DejaVu Serif","Times New Roman"])
	for key in ["closed","unlatched","open_with_generic_contents","open_looted"]:
		chest_textures.append(load("res://assets/runtime/chapter01/rewards/"+key+".png"))
	score_label = Label.new()
	score_label.position = Vector2(910,65)
	score_label.size = Vector2(265,30)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	score_label.add_theme_color_override("font_color",Color("f7d998"))
	score_label.add_theme_font_size_override("font_size",19)
	game.objective.get_parent().add_child(score_label)
func award(key: String, amount: int, at: Vector2, title: String) -> void:
	if key.is_empty() or amount <= 0 or earned.has(key): return
	earned[key] = true
	points += amount
	motes.append({"at":at+Vector2(0,-90),"age":0.0,"text":"+%d  %s" % [amount,title]})
	game.presentation.cue("pickup",at)
func watch_enemy(enemy: Node, key: String) -> void:
	if not is_instance_valid(enemy) or not enemy.has_signal("defeated"): return
	var watch_key := "%d:%s" % [enemy.get_instance_id(),key]
	if watched_enemies.has(watch_key): return
	watched_enemies[watch_key] = true
	var callback := _enemy_defeated.bind(weakref(enemy),key)
	if not enemy.defeated.is_connected(callback): enemy.defeated.connect(callback,CONNECT_ONE_SHOT)

func _enemy_defeated(enemy_ref: WeakRef, key: String) -> void:
	var enemy: Node2D = enemy_ref.get_ref() as Node2D
	if is_instance_valid(enemy): award("enemy:"+key,100,enemy.global_position,"ORCHARD FOE OVERCOME")

func open_chest() -> void:
	if not chest_available or chest_opened: return
	chest_opened = true
	opening = OPEN_DURATION
	animation_time = 0.0
	chest_phase = "rattle"
	game.player.attack_damage = mini(3,game.player.attack_damage+1)
	game.player.health = 5
	game.player.restore_vitality()
	game.player.health_changed.emit(game.player.health)
	award("mossjaw_chest",500,CHEST_FOOT+Vector2(0,-30),"ORCHARD CHARM")
	game._notice("Orchard Charm acquired · Sword strength %d · Lives and vitality restored · +500 points" % game.player.attack_damage)
	game.presentation.cue("puzzle_complete",CHEST_FOOT+Vector2(0,-30))

func preserve_checkpoint() -> void:
	# Do not reset points, earned keys, chest state or rewards on a retry.
	# Reapply only the permanent sword benefit if a respawn restored defaults.
	game.player.attack_damage = mini(3,maxi(game.player.attack_damage,starting_attack_damage+(1 if chest_opened else 0)))

func _process(delta: float) -> void:
	if game.get_tree().paused or not game.player.active: return
	reduced_effects = game.presentation.reduced_effects
	effect_time += delta
	if chest_opened:
		animation_time += delta
		opening = maxf(0,OPEN_DURATION-animation_time)
		chest_phase = "rattle" if animation_time < 0.4 else ("unlatch" if animation_time < 0.85 else ("open" if animation_time < 1.5 else ("reveal" if animation_time < OPEN_DURATION else "looted")))
		reveal_progress = smoothstep(1.05,2.0,animation_time) * (1.0-smoothstep(3.0,OPEN_DURATION,animation_time))
	score_label.visible = game.started and not game.menu.visible
	score_label.text = "TRAIL POINTS  %d" % points
	for item in motes: item.age += delta
	motes = motes.filter(func(item): return item.age < 2.6)
	queue_redraw()

func _diamond(at: Vector2, radius: float, tint: Color) -> void:
	if radius < 1.5:
		draw_line(at-Vector2(radius,0),at+Vector2(radius,0),tint,1,true)
		return
	draw_colored_polygon(PackedVector2Array([at+Vector2(0,-radius),at+Vector2(radius*0.65,0),at+Vector2(0,radius),at-Vector2(radius*0.65,0)]),tint)

func _plaque(text: String, center: Vector2, alpha: float, font_size: int = 16) -> void:
	var width := serif.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x+66
	var rect := Rect2(center-Vector2(width/2,18),Vector2(width,36))
	var style := Ornate.panel_style()
	style.modulate_color = Color(1,1,1,alpha)
	draw_style_box(style,rect)
	var icon_size := Vector2(19,23)
	draw_texture_rect(REWARD_ICON,Rect2(rect.position+Vector2(10,6),icon_size),false,Color(1,1,1,alpha))
	draw_string(serif,rect.position+Vector2(36,24),text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color(1,0.9,0.66,alpha))

func _chest_texture(index: int, alpha: float, squash: float, shift: float) -> void:
	if alpha <= 0: return
	var texture := chest_textures[index]
	# All four alpha-cropped states share the original 512-pixel canvas width.
	# A single source-pixel scale keeps the chest body stable when its lid rises.
	var size := texture.get_size()*0.28
	size.y *= squash
	draw_texture_rect(texture,Rect2(CHEST_FOOT+Vector2(-size.x/2+shift,-size.y),size),false,Color(1,1,1,alpha))

func _draw() -> void:
	if serif == null: return
	for item in motes:
		var age: float = item.age
		var alpha := smoothstep(0.0,0.15,age)*(1.0-smoothstep(1.7,2.6,age))
		_plaque(item.text,item.at+Vector2(0,-minf(age,1.8)*28),alpha)
		if not reduced_effects:
			for i in 6:
				var angle := float(i)*TAU/6
				_diamond(item.at+Vector2.from_angle(angle)*(12+age*32),maxf(0.5,2-age*0.6),Color(1,0.8,0.3,alpha*0.7))
	if not chest_available: return
	var squash := 1.0
	var shift := 0.0
	if chest_phase == "rattle" and not reduced_effects:
		shift = sin(animation_time*52)*2.5*(1-animation_time/0.4)
		squash = 1.0-sin(animation_time/0.4*PI)*0.04
	var first := smoothstep(0.35,0.65,animation_time) if chest_opened else 0.0
	var second := smoothstep(0.85,1.25,animation_time) if chest_opened else 0.0
	var last := smoothstep(3.0,OPEN_DURATION,animation_time) if chest_opened else 0.0
	_chest_texture(0,1-first,squash,shift)
	_chest_texture(1,first*(1-second),1,0)
	_chest_texture(2,second*(1-last),1,0)
	_chest_texture(3,last,1,0)
	if not chest_opened:
		_plaque("MOSSJAW’S CHEST",CHEST_FOOT+Vector2(0,-158),1.0,16)
		if not reduced_effects:
			for i in 18:
				var angle := float(i)*TAU/18+effect_time*0.17
				var at := CHEST_FOOT+Vector2(cos(angle)*84,-64+sin(angle)*70)
				_diamond(at,1.3+sin(effect_time*2+i)*0.7,Color(1,0.78,0.25,0.55))
	if reveal_progress > 0:
		var center := CHEST_FOOT+Vector2(0,-130-35*reveal_progress)
		for i in 4:
			draw_circle(center,30-i*6,Color(1,0.7,0.14,0.035*reveal_progress))
		# The same real reward crystal icon used in the Chapter 1 points panel.
		draw_texture_rect(REWARD_ICON,Rect2(center-Vector2(18,24),Vector2(36,48)),false,Color(1,1,1,reveal_progress))
		_plaque("ORCHARD CHARM",center+Vector2(0,-46),reveal_progress,16)
		if not reduced_effects:
			for i in 24:
				var seed := float(i)*2.39996
				var rise := fmod(animation_time*42+i*11,115.0)
				var at := CHEST_FOOT+Vector2(sin(seed+animation_time)*65,-25-rise)
				_diamond(at,1.8,Color(1,0.86,0.42,reveal_progress*(1-rise/140)))
			for i in 2:
				draw_arc(center,37+i*9,effect_time+i*PI,effect_time+i*PI+PI*0.8,30,Color(1,0.8,0.26,reveal_progress*0.65),1.3,true)
