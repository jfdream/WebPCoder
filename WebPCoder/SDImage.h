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
-(instancetype)initWithDuration:(NSTimeInterval)duration images:(NSArray *)images;

@property (nonatomic, readonly)NSUInteger count;

@property (nonatomic, readonly)NSTimeInterval duration;

@property (nonatomic, readonly)CGSize size;

-(CVPixelBufferRef)nextPixelBuffer;

-(CGImageRef)nextImageRef;

@end

NS_ASSUME_NONNULL_END
