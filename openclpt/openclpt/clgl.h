#ifndef __CLGL_H__
#define __CLGL_H__

/**
 * OpenGL / OpenCL interop code
 */

#include <cstdio>

#ifdef __APPLE__
#include <OpenGL/gl.h>
#include <OpenGL/glext.h>
#include <GLUT/glut.h>
#include <OpenCL/OpenCL.h>
#else
#include <GL/glut.h>
#include <CL/OpenCL.h>
#endif

#define SAFE_RELEASE(c, x) if(x != NULL){c(x); x = NULL;}

void acquireSharedOpenCLContext();
void releaseSharedOpenCLContext();
void releaseSharedOpenCLContext();
cl_mem sharedBuffer(GLuint buffer, cl_mem_flags accessFlags);
void acquireGLBuffer(cl_mem buffer);
void releaseGLBuffer(cl_mem buffer);
cl_command_queue clCommandQueue();
cl_context clContext();
cl_program clProgramFromFile(char* fileName, char* defines);
void clRunKernel(cl_kernel kernel, const size_t minWorkSize[3], const size_t workgroupSize[3]);
const char* errorToString(cl_int error);

#endif
