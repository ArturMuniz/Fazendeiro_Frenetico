extends Node

## Autoload "Pool" — reserva genérica de objetos reutilizáveis.
## Em vez de instantiate()+queue_free() toda hora (caro pro processador
## com muitos inimigos/projéteis na tela), os nós voltam pra uma lista
## e são reaproveitados na próxima vez que alguém precisar de um.
##
## Uso:
##   var node = Pool.acquire(minha_cena)   # pega um pronto ou cria um novo
##   get_tree().current_scene.add_child(node)
##   ... (configurar o node)
##   Pool.release(minha_cena, node)        # devolve pra reserva (não destrói)

var _pools: Dictionary = {}


func acquire(scene: PackedScene) -> Node:
	var list: Array = _pools.get(scene, [])
	while not list.is_empty():
		var candidate: Variant = list.pop_back()
		if is_instance_valid(candidate) and not candidate.is_queued_for_deletion():
			return candidate
	return scene.instantiate()


func release(scene: PackedScene, node: Node) -> void:
	if not is_instance_valid(node) or node.is_queued_for_deletion():
		return
	assert(node.get_parent() == null, "O nó precisa sair da árvore antes de voltar ao pool.")
	var list: Array = _pools.get(scene, [])
	if list.has(node):
		return
	list.append(node)
	_pools[scene] = list


func clear_idle() -> void:
	for list in _pools.values():
		for node in list:
			if is_instance_valid(node):
				node.free()
	_pools.clear()


func _exit_tree() -> void:
	clear_idle()
