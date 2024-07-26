extends Node

@onready var main_menu = $CanvasLayer/PanelContainer
@onready var address_entry = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/IpEntry
@onready var snow_viewport = $Snow/SubViewportContainer/SubViewport

const Player = preload("res://player.tscn")
const SnowBrush = preload("res://snow_brush.tscn")
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
	var snow_brush = SnowBrush.instantiate()
	
	snow_brush.player = player
	snow_brush.name = str(peer_id)
	player.name = str(peer_id)
	
	add_child(player)
	snow_viewport.add_child(snow_brush)
	
	rpc("set_snow_brush_player", str(peer_id), str(peer_id))
	
@rpc("call_local")
func set_snow_brush_player(snow_brush_name, player_name):
	var snow_brush = snow_viewport.get_node(snow_brush_name)
	var player = get_node(player_name)

	if snow_brush and player:
		snow_brush.player = player

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
