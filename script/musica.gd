extends Node

var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

func play_menu_music():
	if music_player.stream == null or not music_player.playing:
		music_player.stream = preload("res://misc/Porker1.mp3")
		music_player.play()

func stop_music():
	music_player.stop()
