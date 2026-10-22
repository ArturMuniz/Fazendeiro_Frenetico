extends SceneTree

func _initialize() -> void: call_deferred("run")
func run() -> void:
	var checks := 0
	var failures := 0
	var rows := VBoxContainer.new()
	root.add_child(rows)
	rows.position=Vector2(30,30)
	for id in ["fazendeiro","vovo","netinho"]:
		var viewport := SubViewport.new()
		viewport.size=Vector2i(384,128)
		viewport.transparent_bg=true
		viewport.render_target_update_mode=SubViewport.UPDATE_ALWAYS
		root.add_child(viewport)
		var skins: Array=SkinCatalog.SKINS.keys()
		for i in range(skins.size()):
			var sprite := Sprite2D.new()
			sprite.texture=GameArt.texture(GameArt.actor(id).idle.frames[0])
			sprite.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.position=Vector2(64+i*128,64)
			SkinCatalog.apply(sprite,id,skins[i])
			viewport.add_child(sprite)
		await process_frame
		await RenderingServer.frame_post_draw
		var rendered := viewport.get_texture().get_image()
		for i in range(1,3):
			var different := 0
			var alpha_ok := true
			for y in range(128):
				for x in range(128):
					var a := rendered.get_pixel(x,y)
					var b := rendered.get_pixel(x+128*i,y)
					alpha_ok=alpha_ok and is_equal_approx(a.a,b.a)
					if a.a>0 and a!=b: different+=1
			checks+=1
			if not alpha_ok or different<80: failures+=1
			print("COSMETIC ",id," ",skins[i]," changed=",different," alpha=",alpha_ok)
		var title := Label.new()
		title.text=id+" · original / colheita / vinho"
		title.add_theme_font_size_override("font_size",22)
		rows.add_child(title)
		var picture := TextureRect.new()
		picture.texture=viewport.get_texture()
		picture.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
		picture.custom_minimum_size=Vector2(576,192)
		picture.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
		rows.add_child(picture)
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://tests/.tmp/skins_integradas.png")
	root.get_node("AudioManager").shutdown()
	print("COSMETIC RESULT checks=%d failures=%d" % [checks,failures])
	quit(1 if failures else 0)
