// Simple passthrough vertex shader

attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_coord;
varying vec3 v_normal;
varying vec3 v_pos;
varying vec4 v_color;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position,1);
    
    v_color = in_Colour;
    v_coord = in_TextureCoord;
	
	v_normal = in_Normal;
	v_pos = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position.xy,in_Position.z,1)).xyz;
}
