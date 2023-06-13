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
    NSArray <NSNumber *>*_intervals;
}
@end

@implementation SDImage

-(instancetype)initWithDuration:(NSTimeInterval)duration images:(nonnull NSArray *)images intervals:(nonnull NSArray *)intervals{
    self = [super init];
    if (self) {
        _images = images;
        _duration = duration;
        CGImageRef image = (__bridge CGImageRef)(images.firstObject);
        _size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
        _intervals = intervals;
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

-(CVPixelBufferRef)copyPixelBufferRef:(NSInteger)i {
    NSInteger index = i % _images.count;
    CGImageRef imageRef = (__bridge CGImageRef)(_images[index]);
    CVPixelBufferRef pixelBuffer = [SDImage CreateCVPixelBufferIOSurface:imageRef];
    return pixelBuffer;
}

-(CGImageRef)copyImageRef:(NSInteger)i {
    NSInteger index = i % _images.count;
    CGImageRef imageRef = (__bridge CGImageRef)(_images[index]);
    CGImageRetain(imageRef);
    return imageRef;
}

-(CVPixelBufferRef)copyPixelBufferForPlaybackTime:(NSTimeInterval)time index:(nonnull NSInteger *)index interval:(nonnull NSTimeInterval *)interval{
    NSTimeInterval duration = 0;
    for (NSInteger i = 0; i < _intervals.count; i ++) {
        duration += [_intervals[i] doubleValue];
        if (duration >= time) {
            CVPixelBufferRef pixelBuffer = [self copyPixelBufferRef:i];
            *index = i;
            *interval = [_intervals[i] doubleValue];
            return pixelBuffer;
        }
    }
    CVPixelBufferRef pixelBuffer = [self copyPixelBufferRef:_intervals.count - 1];
    *index = _intervals.count - 1;
    *interval = _intervals[_intervals.count - 1].doubleValue;
    return pixelBuffer;
}

-(CGImageRef)copyImageRefForPlaybackTime:(NSTimeInterval)time index:(nonnull NSInteger *)index interval:(nonnull NSTimeInterval *)interval{
    NSTimeInterval duration = 0;
    for (NSInteger i = 0; i < _intervals.count; i ++) {
        duration += [_intervals[i] doubleValue];
        if (duration >= time) {
            CGImageRef image = [self copyImageRef:i];
            *index = i;
            *interval = [_intervals[i] doubleValue];
            return image;
        }
    }
    CGImageRef image = [self copyImageRef:_intervals.count - 1];
    *index = _intervals.count - 1;
    *interval = _intervals[_intervals.count - 1].doubleValue;
    return image;
}

-(NSTimeInterval)intervalForPlaybackIndex:(NSInteger)index {
    index = index % _images.count;
    return [_intervals[index] doubleValue];
}

+(CVPixelBufferRef)CreateCVPixelBufferIOSurface:(CGImageRef)imageRef {
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
