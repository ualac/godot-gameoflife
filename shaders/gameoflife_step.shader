shader_type canvas_item;
render_mode unshaded;

// read in a texture of some state and apply a step
// to produce the next iteration in the simulation
//
// in this case the texture is located on the 
// TextureRect node so we can directly access the 
// image using the TEXTURE constant


void fragment()
{
	// get our current cell state
	float cell = textureLod( TEXTURE, UV, 0.0 ).r;
	// assume a square texture and compute size of a pixel in uv space
	float pixel = 1.0/float( textureSize( TEXTURE, 0 ).x );
	// count neighbors by summing up neighboring pixels
	float neighbours = 0.0;
	neighbours += textureLod( TEXTURE, UV + vec2( -pixel, -pixel ), 0.0 ).r;
	neighbours += textureLod( TEXTURE, UV + vec2( 0.0, -pixel ), 0.0 ).r;
	neighbours += textureLod( TEXTURE, UV + vec2( +pixel, -pixel ), 0.0 ).r;
	neighbours += textureLod( TEXTURE, UV + vec2( -pixel, 0.0 ), 0.0 ).r;
	neighbours += textureLod( TEXTURE, UV + vec2( +pixel, 0.0 ), 0.0 ).r;
	neighbours += textureLod( TEXTURE, UV + vec2( -pixel, +pixel ), 0.0 ).r;
	neighbours += textureLod( TEXTURE, UV + vec2( 0.0, +pixel ), 0.0 ).r;
	neighbours += textureLod( TEXTURE, UV + vec2( +pixel, +pixel ), 0.0 ).r;	
	
	//
	// based on number of neighbours and our current state 
	// take one evolutionary step and update our status
	//
	
	if ( ( cell == 0.0 ) && ( neighbours == 3.0 ) )
	{
		// cell is dead but has exactly 3 neighbours 
		// so let's resurrect it
		cell = 1.0;
	}
	else if ( ( cell == 1.0 ) && ( neighbours != 2.0 ) && ( neighbours != 3.0 ) )
	{
		// it's alive but doesn't have 2 or 3 neighbours so 
		// it dies due to loneliness or overcrowding :(
		cell = 0.0;
	}
	
	// output a black or white color for this cell
	// based on whether it's alive or dead
	COLOR.rgb = vec3(cell);
}
