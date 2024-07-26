shader_type spatial;

uniform float uv_scale;
uniform float snow_height;
uniform sampler2D snow_albedo;
uniform sampler2D snow_normal;
uniform sampler2D dynamic_snow_mask; // Ambient Occlusion texture

uniform float albedo_brightness; // Brightness adjustment

void vertex() {
    float snow_mask = COLOR.r * texture(dynamic_snow_mask, UV).r;
    VERTEX.y += snow_mask * snow_height;
}

void fragment() {
    vec2 uv = UV * uv_scale;
    
    vec3 snow_a = texture(snow_albedo, uv).rgb;
    vec3 snow_n = texture(snow_normal, uv).rgb;
    // Adjust albedo color brightness
    vec3 adjusted_albedo = snow_a * albedo_brightness;
    adjusted_albedo *= min(texture(dynamic_snow_mask, UV).r + 0.7, 1.0);
    ALBEDO = adjusted_albedo;
    NORMAL_MAP = snow_n;
}