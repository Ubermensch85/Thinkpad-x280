#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Calibrazione pannello AUO B125HAN02.2 normalizzata per preservare piena brillantezza
const vec3 calibration = vec3(0.95, 0.98, 1.05);
const float brightness = 1.04;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    fragColor = vec4(pixColor.rgb * calibration * brightness, pixColor.a);
}
