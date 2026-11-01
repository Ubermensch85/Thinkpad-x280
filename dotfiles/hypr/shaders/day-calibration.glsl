#version 300 es
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// Calibrazione pannello AUO B125HAN02.2 ottimizzata per condizioni hardware attuali:
// Preserva la piena luminanza, corregge la temperatura colore evitando clipping dei bianchi
// e recupera i toni scuri per prevenire il black crush.
const vec3 calibration = vec3(0.96, 0.98, 1.00);

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 color = pixColor.rgb * calibration;
    fragColor = vec4(clamp(color, 0.0, 1.0), pixColor.a);
}
