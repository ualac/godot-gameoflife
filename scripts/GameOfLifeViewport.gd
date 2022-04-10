extends Control

onready var Surface1 := $ViewportContainer1/Viewport1/GameOfLifeStep1
onready var Surface2 := $ViewportContainer2/Viewport2/GameOfLifeStep2
onready var StartTimer := $Timer


func generate_new_seed_image() -> void :
	var seed_texture : Texture = ImageTexture.new()
	var seed_image : Image = Image.new()
	# create the image data
	seed_image.create( int(rect_size.x), int(rect_size.y), false, Image.FORMAT_L8 )
	seed_image.fill( Color.black )
	# lock the image for editing
	seed_image.lock()
	# setup some random starting conditions filling in ~1/10th of the pixels
	for _c in range( 0, int((rect_size.x*rect_size.y)/10.0)+20 ):
		var x_rand = randi() % int(rect_size.x-2) + 1
		var y_rand = randi() % int(rect_size.y-2) + 1
		seed_image.set_pixel( x_rand, y_rand, Color.white )
	# unlock the image
	seed_image.unlock()
	# generate texture from this image
	# note: only set the repeat flag disabling filtering and mip-maps
	seed_texture.create_from_image( seed_image, Texture.FLAG_REPEAT ) 
	# update the initial seed texture
	Surface1.texture = seed_texture


func _ready() -> void:
	print( "Press SPACE to regenerate a new seed image")
	randomize()
	generate_new_seed_image()
	StartTimer.start()


func _on_Timer_timeout() -> void:
	# copy the viewport texture from viewport2 to be the source of the 
	# viewport1 surface which will trigger the processing loop to begin
	var _last_iteration : Texture = Surface2.get_texture()
	# ensure the texture is repeating only
	_last_iteration.set_flags( Texture.FLAG_REPEAT )
	# light the fuse and slowly back away
	Surface1.texture = _last_iteration


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.scancode == KEY_SPACE :
		# reset the whole thing by generating a new seed image
		generate_new_seed_image()
		StartTimer.start()
	
