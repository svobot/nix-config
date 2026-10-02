vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
    vec3 coords_crop_next =       niri_geo_to_tex_next * niri_curr_geo_to_next_geo * (      coords_curr_geo);
    vec3 coords_shuf_prev = 1.0 - niri_geo_to_tex_prev * niri_curr_geo_to_prev_geo * (1.0 - coords_curr_geo);

    if (0.0 < coords_crop_next.x && coords_crop_next.x < 1.0 &&
        0.0 < coords_crop_next.y && coords_crop_next.y < 1.0) {
        return texture2D(niri_tex_next, coords_crop_next.st);
    } else if (0.0 < coords_shuf_prev.x && coords_shuf_prev.x < 1.0 &&
               0.0 < coords_shuf_prev.y && coords_shuf_prev.y < 1.0) {
        return texture2D(niri_tex_prev, coords_shuf_prev.st);
    } else {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }
}
