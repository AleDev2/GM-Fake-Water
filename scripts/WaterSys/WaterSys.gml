
function WaterDraw(Mesh, X, Y, Level, Xscale, Yscale, Shd, Spd, Res, Alpha, Col, TexRef){
	// Mesh: Model to apply the Water effect.
	// X: Water X Position.
	// Y: Water Y Position.
	// Level: Level of the Water. (Z position)
	// Xscale: Water Width.
	// Yscale: Water Height.
	// Shd: Shader with the Water effect.
	// Spd: Water Waves Speed.
	// Res: Water Resolution. (Bigger = More Details)
	// Alpha: Water Alpha Value.
	// Col: A Array with the Water Color. ([R] [G] [B])
	// TexRef: The skybox for the reflections.
	
	if !(surface_exists(surfWaterRef)) {
		surfWaterRef = surface_create(surface_get_width(application_surface),surface_get_height(application_surface));
	}
	
	surface_set_target(surfWaterRef);
	draw_clear_alpha(c_black,0);
	draw_surface(application_surface, 0, 0);
	surface_reset_target();
	
	shader_set(Shd);
	
	var Time = get_timer()/1000000;
	shader_set_uniform_i(shader_get_uniform(Shd, "uRender"), 1);
	shader_set_uniform_f(shader_get_uniform(Shd, "uSun"), global.SunDirection[0], global.SunDirection[1], global.SunDirection[2], global.SunAmbient);
	shader_set_uniform_f(shader_get_uniform(Shd, "uWater"), Time, Spd, Res, Alpha);
	shader_set_uniform_f(shader_get_uniform(Shd, "uWaterCol"), Col[0], Col[1], Col[2]);
	texture_set_stage(shader_get_sampler_index(Shd, "uTexRef"), sprite_get_texture(TexRef, -1));
	matrix_set(matrix_world, matrix_build(X, Y, Level, 0, 0, 0, Xscale, Yscale, -1));
	vertex_submit(Mesh, pr_trianglelist, surface_get_texture(surfWaterRef));
	matrix_set(matrix_world, matrix_build_identity());
	shader_reset();
}

function InitDrawWaterCaustics(Spd, Res, Col, Wz) {
	// Spd: Caustics Speed.
	// Res: Caustics Resolution
	// Col: A Array with the caustics color. ([R][G][B])
	// Wz: Water Level. (Used to determine if an object is underwater or not.)
	
	shader_set(shCaustics);
	var Time = get_timer()/1000000;
	shader_set_uniform_f(shader_get_uniform(shCaustics, "uWaterLevel"), Wz);
	shader_set_uniform_f(shader_get_uniform(shCaustics, "uSun"), global.SunDirection[0], global.SunDirection[1], global.SunDirection[2], global.SunAmbient);
	shader_set_uniform_f(shader_get_uniform(shCaustics, "uWater"), Time, Spd, Res);
	shader_set_uniform_f(shader_get_uniform(shCaustics, "uWaterCol"), Col[0], Col[1], Col[2]);
}

function EndDrawCaustics() {
	shader_reset();
}
