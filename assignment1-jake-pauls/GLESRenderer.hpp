#ifndef GLESRenderer_hpp
#define GLESRenderer_hpp

#include <stdlib.h>

#include <OpenGLES/ES3/gl.h>

class GLESRenderer
{
public:
    int GenCube(float scale, float **vertices, float **normals, float **texCoords, int **indices);
};

#endif /* GLESRenderer_hpp */
