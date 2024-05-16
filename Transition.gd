extends CanvasLayer

func reload():
	$Fader.play('fadeout')
	await $Fader.animation_finished
	get_node("/root/Main/ViewBox/ViewPort/World").reload()
	$Fader.play_backwards('fadeout')
	
	get_node("/root/Main/Interstitial")._on_show_pressed()
	
	
func enter():
	$Fader.play_backwards('fadeout')
	get_node("/root/Main/Banner").banner_load()
