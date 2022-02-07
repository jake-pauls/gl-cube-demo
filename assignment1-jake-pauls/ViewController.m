#import "ViewController.h"

@interface ViewController () {
    ViewRenderer *glesRenderer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    glesRenderer = [[ViewRenderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    [glesRenderer setup:view];
    [glesRenderer load];
}

- (void)update
{
    [glesRenderer update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [glesRenderer draw:rect];
}

@end
