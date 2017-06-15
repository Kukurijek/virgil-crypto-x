//
//  VSCPfsPublicKey.h
//  VirgilCrypto
//
//  Created by Oleksandr Deundiak on 6/14/17.
//  Copyright © 2017 VirgilSecurity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSCPfsPublicKey : NSObject

- (instancetype __nullable)initWithKey:(NSData * __nonnull)key;

- (instancetype __nonnull)init NS_UNAVAILABLE;

@property (nonatomic, readonly) BOOL isEmpty;
@property (nonatomic, readonly) NSData * __nonnull key;

@end
