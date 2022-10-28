// Simple passthrough fragment shader

varying vec2 v_coord;
varying vec3 v_normal;

varying vec3 v_pos;
varying vec4 v_color;

uniform vec4 uSun; // xyz = Light Direction, w = light ambient intensity.

uniform vec3 uWater; //Time, Time Speed, Water Res
uniform vec3 uWaterCol; // Water Color

uniform float uWaterLevel;

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

void main()
{
	// Compute the caustics.
	vec2 q = v_coord * uWater.z;
	float k = water(q),
	f = smoothstep(0.2,1.0,1.0-abs(k)) * 2.0;
	vec3 col = texture2D(gm_BaseTexture,v_coord).rgb;
	col *= (uWaterCol/255.) * (f>.5? f : 1.-abs(f));
	
	// Calculate the Water Level.
	float p = v_pos.z - uWaterLevel;
	
	// Compute a simple diffuse lighting.
	vec3 n = normalize(v_normal);
	float dif = max(uSun.w, dot(n, normalize(uSun.xyz)));
	
	// Check the water level.
	if(p > 0.0)
		gl_FragColor = vec4(col*dif,1); // UnderWater.
	else
		gl_FragColor = vec4(texture2D(gm_BaseTexture,v_coord).rgb*dif,1); // No Water.
	
	
	//gl_FragColor = vec4(vec3(p),1); // Water level only for test.
}
