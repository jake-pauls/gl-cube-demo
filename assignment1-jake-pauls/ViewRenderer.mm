#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#include <chrono>

#import "ViewRenderer.h"
#include "Assert.hpp"
#include "Shader.hpp"
#include "GLESRenderer.hpp"

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    NUM_UNIFORMS
};

GLint uniforms[NUM_UNIFORMS];

@interface ViewRenderer() {
    GLKView *theView;
    GLESRenderer glesRenderer;
    GLuint programObject;
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
    numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
}

- (void)setup:(GLKView *)view
{
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (!view.context) {
        NSLog(@"Failed to create ES context");
    }
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    theView = view;
    [EAGLContext setCurrentContext:view.context];
    
    if (![self setupShaders])
        return;
    
    rotAngle = 0.0f;
    isRotating = 1;
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glEnable(GL_DEPTH_TEST);
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

    // Perspective
    mvp = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, -5.0);
    mvp = GLKMatrix4Rotate(mvp, rotAngle, 1.0, 0.0, 1.0 );
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);

    float aspect = (float)theView.drawableWidth / (float)theView.drawableHeight;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(60.0f * M_PI / 180.0f, aspect, 1.0f, 20.0f);

    mvp = GLKMatrix4Multiply(perspective, mvp);
}

- (void)draw:(CGRect)drawRect;
{
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *) mvp.m);

    glViewport(0, 0, (int) theView.drawableWidth, (int) theView.drawableHeight);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), vertices);
    glEnableVertexAttribArray(0);

    glVertexAttrib4f(1, 1.0f, 0.0f, 0.0f, 1.0f);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *)mvp.m);
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, indices);
}


- (bool)setupShaders
{
    Shader::ProgramSource vShaderSource = Shader().parseShader([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.vsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.vsh"] pathExtension]] cStringUsingEncoding:1]);
    
    Shader::ProgramSource fShaderSource = Shader().parseShader([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.fsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.fsh"] pathExtension]] cStringUsingEncoding:1]);
    
    programObject = Shader().createShader(vShaderSource.vertexSource, fShaderSource.fragmentSource);
    GL_CALL(glUseProgram(programObject));
    ASSERT(programObject != 0)
    
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");

    return true;
}

@end
