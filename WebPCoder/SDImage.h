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
-(instancetype)initWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer duration:(NSTimeInterval)duration;

@property (nonatomic, readonly)CVPixelBufferRef pixelBuffer;

@property (nonatomic, readonly)NSTimeInterval duration;
@end

NS_ASSUME_NONNULL_END
