
varying vec2 v_coord;

varying vec3 v_normal;
varying vec3 v_view;

varying vec4 v_GLPOS;

uniform int uRender; // 1 For see the normals of the water.
uniform vec4 uSun; // xyz = Light Direction, w = light ambient intensity.
uniform vec4 uWater; //Time, Time Speed, Water Res, Water Opacity
uniform vec3 uWaterCol; // Water Color
uniform sampler2D uTexRef; // Texture for the Reflections

#define WavesIntesity 0.75 // Waves normal intesity.

float hash(vec2 q) {
	return fract(sin(q.x*50.12+q.y*81.10)*1245.6721);
}

float noise(vec2 q) {
	vec2 c = floor(q), f = fract(q);
	vec2 u = f*f*(3.-2.*f), o = vec2(1.,0.);
	return mix(mix(hash(c+o.yy), hash(c+o.xy), u.x), mix(hash(c+o.yx), hash(c+o.xx), u.x), u.y);
}

float fbm(vec2 q) {
	mat2 m = mat2(1.8, 1.6, -1.6, 1.8); float a;
	a += 0.5000*noise(q); q = m * q;
	a += 0.2500*noise(q); q = m * q;
	a += 0.1250*noise(q); q = m * q;
	a += 0.0625*noise(q); q = m * q;
	
	return a;
}

float water(vec2 q) {
	return fbm(q + fbm(q + fbm(q + uWater.x * uWater.y)));
}

vec3 water_norm(vec2 q, float s) {
	vec2 ep = vec2(-1,1)*.01;
	float h = water(q);
	vec2 n = h - vec2(water(q + vec2(ep.x, 0.)),water(q + vec2(0., ep.y)));
	return normalize(vec3(n*s/ep,1.));
}


void main()
{
	// set water res and light pos.
	vec2 uvProj = v_GLPOS.xy/v_GLPOS.w*.5+.5;
	vec2 uv = v_coord * uWater.z;
	vec3 light = normalize(uSun.xyz);
	
	// compute the water normal.
	vec3 norm = normalize(v_normal) * 0.5 + 0.5;
	norm *= cos(water_norm(uv, WavesIntesity) * 0.5 + 0.5);
	
	// set the water texture.
	vec4 tex = texture2D(gm_BaseTexture, mix(uvProj, norm.xy, 0.05));
	
	// compute the view, reflection vector.
	vec3 view = normalize(v_view);
	vec3 ref = reflect(-view, norm);
	
	// basic lighting.
	float dif = max(uSun.w, dot(norm,light));
	float spec = max(0.0, dot(norm,ref));
	
	// set the water color and compute the reflections.
	vec3 waterCol = (uWaterCol.rgb/255.);//vec3(0.,.6,.8);//vec3(0.022,.275,.30);
	
	vec2 q = vec2(atan(-ref.z, -ref.x) * 0.15915494 + .5, ref.y  * .5 + .5);
	waterCol *= texture2D(uTexRef, q).rgb*spec; // Reflections
	
	// mix the water texture and the color with the reflections.
	tex.rgb = mix(tex.rgb,waterCol,uWater.w)/2.0;
	
	// output
	gl_FragColor = (uRender < 1? vec4(norm,1) : vec4(tex.rgb*(dif+spec), 1.0));
}