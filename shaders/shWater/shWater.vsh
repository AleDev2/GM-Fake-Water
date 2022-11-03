// Simple passthrough vertex shader

attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_coord;
varying vec3 v_normal;
varying vec3 v_view;
varying vec4 v_GLPOS;

void main()
{
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION]*vec4(in_Position,1.);
	
	v_coord = in_TextureCoord;
	v_normal = (gm_Matrices[MATRIX_WORLD]*vec4(in_Normal,1)).xyz;
	v_view = (gm_Matrices[MATRIX_WORLD]*vec4(in_Position,1.)).xyz;
	v_GLPOS = gl_Position;
}
