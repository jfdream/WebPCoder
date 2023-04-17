//
//  SDImage.h
//  WebPCoder
//
//  Created by 杨雨东 on 2023/4/16.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDImage : NSObject
-(instancetype)initWithDuration:(NSTimeInterval)duration images:(NSArray *)images;

@property (nonatomic, readonly)NSTimeInterval duration;

-(CVPixelBufferRef)nextPixelBuffer;

@end

NS_ASSUME_NONNULL_END
