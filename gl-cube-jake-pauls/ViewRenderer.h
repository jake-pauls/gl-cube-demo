#ifndef Renderer_h
#define Renderer_h

#import <GLKit/GLKit.h>

@class Transform;

@interface ViewRenderer : NSObject

@property Transform* transform;

- (void)setup:(GLKView *)view;
- (void)load;
- (void)update;
- (void)draw:(CGRect)drawRect;

@end

#endif /* Renderer_h */
