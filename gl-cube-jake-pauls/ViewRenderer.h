#ifndef Renderer_h
#define Renderer_h

#import <GLKit/GLKit.h>

@class Test;

@interface ViewRenderer : NSObject

@property float rotAngle;
@property bool isRotating;

- (void)setup:(GLKView *)view;
- (void)load;
- (void)update;
- (void)draw:(CGRect)drawRect;

@end

#endif /* Renderer_h */
