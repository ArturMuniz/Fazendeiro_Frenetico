extends Node
## Explicit development simulation; never an actual advertisement.
signal available
signal shown(token: int)
signal earned(token: int)
signal closed(token: int)
signal failed(token: int, message: String)
var _layer: CanvasLayer

func start() -> void:
	available.emit()

func show_rewarded(token: int) -> void:
	_layer = CanvasLayer.new()
	_layer.layer = 100
	_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_layer)
	var view := RuralUI.shell(_layer, "Simulação de anúncio", "Ferramenta de teste. Nenhum anúncio real é exibido.")
	view.body.add_child(RuralUI.label("No Android, a recompensa depende da confirmação do provedor. Aqui você pode testar os dois resultados.", 26))
	view.footer.add_child(RuralUI.button("Simular anúncio concluído", _complete.bind(token)))
	view.footer.add_child(RuralUI.button("Fechar sem recompensa", _close.bind(token)))
	shown.emit(token)

func _complete(token: int) -> void:
	earned.emit(token)
	_close(token)

func _close(token: int) -> void:
	if is_instance_valid(_layer):
		_layer.queue_free()
	closed.emit(token)

func cancel(_token: int) -> void:
	if is_instance_valid(_layer):
		_layer.queue_free()
