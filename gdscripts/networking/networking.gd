extends Node

@onready var main_menu = $CanvasLayer/PanelContainer
@onready var address_entry = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/IpEntry

const Player = preload("res://player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _on_host_pressed():
	main_menu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
func _on_join_pressed():
	main_menu.hide()
	
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	
	player.name = str(peer_id)
	
	add_child(player)
	
func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
