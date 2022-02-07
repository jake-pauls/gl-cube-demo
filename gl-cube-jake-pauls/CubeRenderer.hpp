#ifndef CubeRenderer_hpp
#define CubeRenderer_hpp

#include <stdlib.h>

#include <OpenGLES/ES3/gl.h>

class CubeRenderer
{
public:
    int drawCube(float scale, float **vertices, float **normals, float **texCoords, int **indices);
};

#endif /* CubeRenderer_hpp */
