// @Description:

if(keyboard_check(vk_shift)) {
	pFov = lerp(pFov, 75, 0.1);
	pSpd = lerp(pSpd, 0.80, 0.1);
} else {
	pFov = lerp(pFov, 60, 0.1);
	pSpd = lerp(pSpd, 0.25, 0.1);
}

