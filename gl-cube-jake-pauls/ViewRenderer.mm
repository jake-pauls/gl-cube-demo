#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include <chrono>

#import "ViewRenderer.h"

#include "Assert.hpp"
#include "Shader.hpp"
#include "CubeRenderer.hpp"

enum
{
    UNIFORM_MVP_MATRIX,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

@interface ViewRenderer() {
    GLKView *viewport;
    CubeRenderer renderer;
    
    std::chrono::time_point<std::chrono::steady_clock> lastTime;

    GLKMatrix4 mvp;
    GLKMatrix3 normalMatrix;

    float *vertices, *normals, *texCoords;
    int *indices, numIndices;
}

@end

@implementation ViewRenderer

@synthesize isRotating;
@synthesize rotAngle;

- (void)load
{
    numIndices = renderer.drawCube(1.0f, &vertices, &normals, &texCoords, &indices);
}

- (void)setup:(GLKView *)view
{
    // Configure view context
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    ASSERT(view.context);
    
    [EAGLContext setCurrentContext:view.context];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    viewport = view;
    
    // Setup shaders
    ASSERT([self setupShaders]);
    
    // Clear/update buffers
    GL_CALL(glClearColor(0.0f, 0.0f, 0.0f, 0.0f));
    GL_CALL(glEnable(GL_DEPTH_TEST));
    
    // Initialize instance variables
    rotAngle = 0.0f;
    isRotating = 1;
    lastTime = std::chrono::steady_clock::now();
}

- (void)update
{
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastTime).count();
    lastTime = currentTime;
    
    if (isRotating)
    {
        rotAngle += 0.001f * elapsedTime;
        
        if (rotAngle >= 360.0f)
            rotAngle = 0.0f;
    }

    // Perspective view
    mvp = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, -5.0);
    mvp = GLKMatrix4Rotate(mvp, rotAngle, 1.0, 0.0, 1.0 );
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);

    float aspect = (float)viewport.drawableWidth / (float)viewport.drawableHeight;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(60.0f * M_PI / 180.0f, aspect, 1.0f, 20.0f);

    mvp = GLKMatrix4Multiply(perspective, mvp);
}

- (void)draw:(CGRect)drawRect
{
    glUniformMatrix4fv(uniforms[UNIFORM_MVP_MATRIX], 1, FALSE, (const float *) mvp.m);

    glViewport(0, 0, (int) viewport.drawableWidth, (int) viewport.drawableHeight);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), vertices);
    glEnableVertexAttribArray(0);

    glVertexAttrib4f(1, 1.0f, 0.0f, 0.0f, 1.0f);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MVP_MATRIX], 1, FALSE, (const float *)mvp.m);
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, indices);
}

- (bool)setupShaders
{
    Shader::ProgramSource shaderSource;
    shaderSource.vertexSource = Shader().parseShader([self retrieveFilePathByName:"Shader.vsh"]).vertexSource;
    shaderSource.fragmentSource = Shader().parseShader([self retrieveFilePathByName:"Shader.fsh"]).fragmentSource;
    
    GLuint programObject = Shader().createShader(shaderSource.vertexSource, shaderSource.fragmentSource);
    GL_CALL(glUseProgram(programObject));
    ASSERT(programObject != 0)
    
    uniforms[UNIFORM_MVP_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");

    return true;
}

- (const char*)retrieveFilePathByName:(const char*)fileName
{
    return [[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:fileName] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:fileName] pathExtension]] cStringUsingEncoding:1];
}

@end
