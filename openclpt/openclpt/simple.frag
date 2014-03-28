#version 100

precision mediump float;

// Simple texture display shader
// Displays texture with coords

// From vertex shader
varying vec2 coords;

// Uniforms
uniform float iterCount;
uniform float userScale;

// Textures
uniform sampler2D displayTexture;

// Output
//out vec4 outColor;

void main() {
	gl_FragColor = (texture(displayTexture, coords) / userScale) / iterCount;
}

/*
#version 420 core

// Simple texture display shader
// Displays texture with coords

// From vertex shader
in vec2 coords;

// Uniforms
uniform float iterCount;
uniform float userScale;

// Textures
uniform sampler2D displayTexture;

// Output
out vec4 outColor;

void main() {
	outColor = (texture(displayTexture, coords) / userScale) / iterCount;
}
*/