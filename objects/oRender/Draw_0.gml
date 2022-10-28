// @Description:

var cx, cy, mx, my;

cx = window_get_width()/2;
cy = window_get_height()/2;

mx = window_mouse_get_x()-cx;
my = window_mouse_get_y()-cy;

window_mouse_set(cx, cy);

dx = dx + mx * 0.20;
dy = clamp(dy + my * 0.20, -89, 89);

viewMatrix = matrix_build_lookat(px, py, pz, px + (dcos(dy)*dcos(dx)), py + (dcos(dy)*dsin(dx)), pz + dsin(dy), 0, 0, 1);
projMatrix = matrix_build_projection_perspective_fov(pFov, 16/9, 1, 10000);

var kx, ky, kz;

kx = (keyboard_check(ord("W"))-keyboard_check(ord("S")));
ky = (keyboard_check(ord("A"))-keyboard_check(ord("D")));
kz = (keyboard_check(ord("E"))-keyboard_check(ord("Q")));

WaterZ += (keyboard_check(vk_down)-keyboard_check(vk_up));

px += ((dcos(dx)*kx)+(dsin(dx)*ky)) * pSpd;
py += ((dsin(dx)*kx)-(dcos(dx)*ky)) * pSpd;
pz += kz * pSpd;

camera_set_proj_mat(view_camera[0], projMatrix);
camera_set_view_mat(view_camera[0], viewMatrix);

camera_apply(view_camera[0]);

// Draw the objects

// Draw the objects that can interacts with the water.

InitDrawWaterCaustics(WaterSpd, WaterRes, WaterCol, WaterZ);

matrix_set(matrix_world, matrix_build(-50, 50, -5, 0, 0, 0, 10, 10, -10));
vertex_submit(base, pr_trianglelist, sprite_get_texture(sTex, -1));
matrix_set(matrix_world, matrix_build_identity());

matrix_set(matrix_world, matrix_build(50, 50, 90, 0, 0, 0, sceneTestSize, sceneTestSize, -sceneTestSize));
vertex_submit(testScene, pr_trianglelist, sprite_get_texture(sTex, -1));
matrix_set(matrix_world, matrix_build_identity());

EndDrawCaustics();


WaterDraw(waterScene, 50, 50, WaterZ, sceneTestSize, sceneTestSize, shWater, WaterSpd, WaterRes, WaterAlpha, WaterCol, sReflections);