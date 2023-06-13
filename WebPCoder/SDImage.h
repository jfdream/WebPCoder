//
//  SDImage.h
//  WebPCoder
//
//  Created by 杨雨东 on 2023/4/16.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDImage : NSObject
-(instancetype)initWithDuration:(NSTimeInterval)duration images:(nonnull NSArray *)images intervals:(nonnull NSArray *)intervals;

@property (nonatomic, readonly)NSUInteger count;

@property (nonatomic, readonly)NSTimeInterval duration;

@property (nonatomic, readonly)CGSize size;

-(CVPixelBufferRef)copyPixelBufferRef:(NSInteger)i;

-(CGImageRef)copyImageRef:(NSInteger)i;

-(NSTimeInterval)intervalForPlaybackIndex:(NSInteger)index;

-(CVPixelBufferRef)copyPixelBufferForPlaybackTime:(NSTimeInterval)time index:(NSInteger *)index interval:(NSTimeInterval *)interval;

-(CGImageRef)copyImageRefForPlaybackTime:(NSTimeInterval)time index:(NSInteger *)index interval:(NSTimeInterval *)interval;


@end

NS_ASSUME_NONNULL_END
