//
//  Biometrics.h
//  Oak
//
//  Created by Alex Catchpole on 17/05/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Biometrics : NSObject

+ (void)enrolled;
+ (void)unenrolled;
+ (void)successfulAuthentication;
+ (void)unsuccessfulAuthentication;

@end

NS_ASSUME_NONNULL_END
