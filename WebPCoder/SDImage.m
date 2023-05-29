//
//  SDImage.m
//  WebPCoder
//
//  Created by 杨雨东 on 2023/4/16.
//

#import "SDImage.h"
#import "webp/decode.h"
#import "webp/encode.h"
#import "webp/demux.h"
#import "webp/mux.h"
#import "SDImageWebPCoder.h"

@interface SDImage ()
{
    NSArray *_images;
    NSInteger _i;
}
@end

@implementation SDImage

-(instancetype)initWithDuration:(NSTimeInterval)duration images:(nonnull NSArray *)images{
    self = [super init];
    if (self) {
        _images = images;
        _duration = duration;
    }
    return self;
}

-(NSUInteger)count {
    return _images.count;
}

-(void)dealloc {
    [_images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGImageRef x = (__bridge CGImageRef)(obj);
        CGImageRelease(x);
    }];
}

-(CVPixelBufferRef)nextPixelBuffer {
    CGImageRef imageRef = (__bridge CGImageRef)(_images[_i ++ % _images.count]);
    CVPixelBufferRef pixelBuffer = [SDImage createCVPixelBufferIOSurface:imageRef];
    return pixelBuffer;
}

-(CGImageRef)nextImageRef {
    CGImageRef imageRef = (__bridge CGImageRef)(_images[_i ++ % _images.count]);
    CGImageRetain(imageRef);
    return imageRef;
}

+(CVPixelBufferRef)createCVPixelBufferIOSurface:(CGImageRef)imageRef {
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    NSDictionary *attributes = @{
        (NSString *)kCVPixelBufferIOSurfacePropertiesKey:@{},
        (NSString *)kCVPixelBufferOpenGLCompatibilityKey:@YES,
        (NSString *)kCVPixelBufferMetalCompatibilityKey:@YES,
        (NSString *)kCVPixelBufferCGImageCompatibilityKey:@YES,
        (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey:@YES};
    CVPixelBufferRef pixelBufferOut;
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef _Nullable)(attributes), &pixelBufferOut);
    CGColorSpaceRef specifiedColorSpace = CGImageGetColorSpace(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceGetModel(specifiedColorSpace) == kCGColorSpaceModelRGB ? CGColorSpaceRetain(specifiedColorSpace) : CGColorSpaceCreateDeviceRGB();
    CVPixelBufferLockBaseAddress(pixelBufferOut, 0);
    CGContextRef context = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(pixelBufferOut),
                                                   width,
                                                   height,
                                                   8,
                                                   CVPixelBufferGetBytesPerRow(pixelBufferOut),
                                                   colorSpace,
                                                   kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    if (!context){
        CVPixelBufferUnlockBaseAddress(pixelBufferOut, 0);
        return pixelBufferOut;
    }
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pixelBufferOut, 0);
    return pixelBufferOut;
}

@end
