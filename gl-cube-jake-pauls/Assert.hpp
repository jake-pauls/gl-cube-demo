//
// Assert.hpp
// Created by Jake Pauls
//

#ifndef Assert_hpp
#define Assert_hpp

#include <iostream>
#include <OpenGLES/ES3/gl.h>

#define ASSERT(x) if (!(x)) {}

#define GL_CALL(x) GLClearErrors();\
    x;\
    ASSERT(GLLogCall(#x, __FILE__, __LINE__))

void GLClearErrors();
bool GLLogCall(const char* function, const char* file, int lineNumber);

#endif /* Assert_hpp */
