//
//  VSCBaseCipherPrivate.h
//  VirgilCypto
//
//  Created by Pavel Gorb on 2/23/16.
//  Copyright © 2016 VirgilSecurity. All rights reserved.
//

#import "VSCBaseCipher.h"

@interface VSCBaseCipher ()

/** 
 * This property is supposed to be used by subclasses.
 * It is managed automatically and not supposed to be changed
 * by the third party code.
 * 
 * Any changes to this property will lead to unpredicted results.
 */
@property (nonatomic, assign, readwrite) void * __nullable llCipher;

/** 
 * This method supposed to be overwritten in subclasses to create proper Cipher object.
 * It is called from constructor automatically. 
 *
 * It is not supposed to be called manually. 
 */
- (void)initializeCipher;

@end
