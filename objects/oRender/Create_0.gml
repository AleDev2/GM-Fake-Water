// @Description:

WaterZ = 64;
WaterSpd = 0.25;
WaterRes = 2;
//WaterCol = [255,25,15]; // Red
WaterCol = [5,125,225]; // Blue
//WaterCol = [255,255,255]; // White
WaterAlpha = 0.5;

global.SunDirection = [32., 0.5, 400.];
global.SunAmbient = 0.25;

sceneTestSize = 20;

window_set_cursor(cr_none);

gpu_set_zwriteenable(1);
gpu_set_ztestenable(1);
gpu_set_tex_repeat(1);

px = 0;
py = 0;
pz = 0;

pSpd = 0.25;
pFov = 60;

dx = 0;
dy = 0;

#region Generate a plane for the Water. (Test)
/*
vertex_format_begin();
vertex_format_add_color();
vertex_format_add_normal();
vertex_format_add_position_3d();
vertex_format_add_texcoord();

wFormat = vertex_format_end();
wBuffer = vertex_create_buffer();

vertex_begin(wBuffer, wFormat);

vertex_color(wBuffer, c_white, 1);
vertex_normal(wBuffer, 0, 0, -1);
vertex_position_3d(wBuffer, 0, 0, 0);
vertex_texcoord(wBuffer, 0, 0);

vertex_color(wBuffer, c_white, 1);
vertex_normal(wBuffer, 0, 0, -1);
vertex_position_3d(wBuffer, 10, 0, 0);
vertex_texcoord(wBuffer, 1, 0);

vertex_color(wBuffer, c_white, 1);
vertex_normal(wBuffer, 0, 0, -1);
vertex_position_3d(wBuffer, 0, 10, 0);
vertex_texcoord(wBuffer, 0, 1);


vertex_color(wBuffer, c_white, 1);
vertex_normal(wBuffer, 0, 0, -1);
vertex_position_3d(wBuffer, 10, 0, 0);
vertex_texcoord(wBuffer, 1, 0);

vertex_color(wBuffer, c_white, 1);
vertex_normal(wBuffer, 0, 0, -1);
vertex_position_3d(wBuffer, 0, 10, 0);
vertex_texcoord(wBuffer, 0, 1);

vertex_color(wBuffer, c_white, 1);
vertex_normal(wBuffer, 0, 0, -1);
vertex_position_3d(wBuffer, 10, 10, 0);
vertex_texcoord(wBuffer, 1, 1);

vertex_end(wBuffer);
/*/
#endregion

skyBox = load_obj("SkyBox.obj");
base = load_obj("Base.obj");
testScene = load_obj("TestScene.obj");
waterScene = load_obj("TestWater.obj");

viewMatrix = -1;
projMatrix = matrix_build_projection_perspective_fov(pFov, 16/9, 1, 1000000);


surfWaterRef = -1;