extends Node2D

var _inter : InterstitialAd

# Called when the node enters the scene tree for the first time.
func _ready():
	MobileAds.initialize()


func inter_load():

	#Release the ad if there is currently one
	inter_free()

	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/1033173712"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/4411468910"

	var inter_callback := InterstitialAdLoadCallback.new()
	inter_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)

	inter_callback.on_ad_loaded = func(inter : InterstitialAd) -> void:
		print("interstitial ad loaded" + str(inter._uid))
		_inter = inter

	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), inter_callback)
	
func inter_show():
	if _inter:
		_inter.show()
		
func inter_free():
	if _inter:
		_inter.destroy()
		_inter = null
