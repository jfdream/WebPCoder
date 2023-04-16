//
//  SDImage.m
//  WebPCoder
//
//  Created by 杨雨东 on 2023/4/16.
//

#import "SDImage.h"

@implementation SDImage
-(instancetype)initWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer duration:(NSTimeInterval)duration{
    self = [super init];
    if (self) {
        _pixelBuffer = pixelBuffer;
        _duration = duration;
        CVPixelBufferRetain(pixelBuffer);
    }
    return self;
}

-(void)dealloc {
    CVPixelBufferRelease(_pixelBuffer);
}
@end
