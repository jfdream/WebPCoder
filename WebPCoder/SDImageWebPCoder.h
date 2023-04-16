/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import <WebPCoder/SDImageIOAnimatedCoder.h>
#import <WebPCoder/SDImage.h>


/**
 Built in coder that supports WebP and animated WebP
 */
@interface SDImageWebPCoder : NSObject<SDProgressiveImageCoder, SDAnimatedImageCoder>

@property (nonatomic, class, readonly, nonnull) SDImageWebPCoder *sharedCoder;

- (NSArray <SDImage *> *_Nullable)decodedAnimatedImageWithData:(NSData *_Nullable)data options:(nullable SDImageCoderOptions *)options;

@end
