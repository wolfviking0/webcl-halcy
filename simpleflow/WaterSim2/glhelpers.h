#ifndef _GLHELPERS_H_
#define _GLHELPERS_H_


// Includes
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#ifdef __APPLE__
#include <OpenGL/gl.h>
#include <GLUT/glut.h>
#include <OpenCL/OpenCL.h>
#else
#include <GL/glew.h>
#include <GL/glut.h>
#include <CL/OpenCL.h>
#endif

#include "Vector.h"

#define min(a,b) ((a)<(b)?(a):(b))
#define max(a,b) ((a)>(b)?(a):(b))

GLuint makeBO(GLenum type, void* data, GLsizei size, int accessFlags);
GLuint makeTextureBuffer(int w, int h, GLenum format, GLint internalFormat);
GLuint loadShader(GLenum type, char *file);
GLuint makeShaderProgram(GLuint vertexShader, GLuint fragmentShader);
GLuint loadTexture(const char *filename);
void registerGlDebugLogger(unsigned int logLevel);
char* loadFile(char* name);
Matrix lookatMatrix(Vector eye, Vector center, Vector up);
GLuint genFloatTexture(float *data, int width, int height);

#endif