shader_type canvas_item;
uniform sampler2D tex_prev : filter_nearest;
uniform sampler2D tex_next : filter_nearest;
uniform float progress = 0.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment(){
    vec2 uv = SCREEN_UV;

    float dx = abs(dFdx(uv.x));
    float dy = abs(dFdy(uv.y));
    float aspect = dy / dx;

    vec2 p = (uv - center) * vec2(aspect, 1.0);
    float d = length(p);

    vec2 far = max(center, 1.0 - center) * vec2(aspect, 1.0);
    float r = progress * length(far);

    float edge_width = fwidth(d);
    float mask = smoothstep(r - edge_width, r, d);

    COLOR = mix(texture(tex_next, uv), texture(tex_prev, uv), mask);
}