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
	if list.size() > 0:
		return list.pop_back()
	return scene.instantiate()


func release(scene: PackedScene, node: Node) -> void:
	var list: Array = _pools.get(scene, [])
	list.append(node)
	_pools[scene] = list
