//
//  VSCBaseCipher.h
//  VirgilCypto
//
//  Created by Pavel Gorb on 2/23/16.
//  Copyright © 2016 VirgilSecurity. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Error domain constant for the VSCBaseCipher errors.
NS_SWIFT_NAME(kBaseCipherErrorDomain)
extern NSString * __nonnull const kVSCBaseCipherErrorDomain;

/**
 Base class for `VSCCipher`, `VSCStreamCipher` and `VSCChunkCipher`.
 
 Contains utility functionality for adding/removing the recipients and content info management.
 */
NS_SWIFT_NAME(BaseCipher)
@interface VSCBaseCipher : NSObject
/**
 Internal Cipher object
 */
@property (nonatomic, assign, readonly) void * __nullable llCipher;
/**
 Adds given public key as a recipient for an encryption.

 This method should be called before methods:
 
 - `[VSCCipher encryptData:embedContentInfo:error:]`
 - `[VSCStreamCipher encryptDataFromStream:toStream:embedContentInfo:error:]`
 - `[VSCChunkCipher startEncryptionWithPreferredChunkSize:error:]`
 
 in case of using key-based encryption.
 
 @param recipientId Identifier for the public key used for encryption.
 @param publicKey Data object containing public key which will be used for encryption.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)addKeyRecipient:(NSData * __nonnull)recipientId publicKey:(NSData * __nonnull)publicKey error:(NSError * __nullable * __nullable)error;

/**
 Removes a public key with given identifier from the recipients list for an encryption.

 @param recipientId Identifier for the public key which should be removed.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)removeKeyRecipient:(NSData * __nonnull)recipientId error:(NSError * __nullable * __nullable)error;

/**
 Check whether recipient with given identifier exists.

 Search order:
 
 1. Local structures - useful when cipher is used for
 2. ContentInfo structure - useful when cipher is used for decryption.
 
 @param recipientId Recipient's unique identifier.
 @return `YES` if recipient with given identifier exists, `NO` - otherwise.
 */
- (BOOL)isKeyRecipientExists:(NSData *__nonnull)recipientId;

/**
 Adds given password as a recipient for an encryption.
 
 This method should be called before methods:
 
 - `[VSCCipher encryptData:embedContentInfo:error:]`
 - `[VSCStreamCipher encryptDataFromStream:toStream:embedContentInfo:error:]`
 - `[VSCChunkCipher startEncryptionWithPreferredChunkSize:error:]`

 @param password Password which will be used for an encryption.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)addPasswordRecipient:(NSString * __nonnull)password error:(NSError * __nullable * __nullable)error;

/**
 Removes given password from the recipients list for an encryption.

 @param password Password which should be removed.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)removePasswordRecipient:(NSString * __nonnull)password error:(NSError * __nullable * __nullable)error;

/**
 Removes all recepients which would be used for an encryption.

 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)removeAllRecipientsWithError:(NSError * __nullable * __nullable)error;

/**
 Allows to get the content info data.

 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Data object with content info for the encryption data or `nil` in case of error or if no content info present.
 */
- (NSData * __nullable)contentInfoWithError:(NSError * __nullable * __nullable)error;

/**
 Allows to set the content info data with information about the encryption recipients.
 
 This method should be called before methods:
 
 - `[VSCCipher decryptData:recipientId:privateKey:keyPassword:error:]`
 - `[VSCCipher decryptData:password:error:]`
 - `[VSCStreamCipher decryptFromStream:toStream:recipientId:privateKey:keyPassword:error:]`
 - `[VSCStreamCipher decryptFromStream:toStream:password:error:]`
 - `[VSCChunkCipher startDecryptionWithRecipientId:privateKey:keyPassword:error:]`
 - `[VSCChunkCipher startDecryptionWithPassword:error:]`

 @param contentInfo Data object with content info for the data decryption.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)setContentInfo:(NSData * __nonnull)contentInfo error:(NSError * __nullable * __nullable)error;

/**
 Calculates content info size which is a part of the given data.

 @param data Data object with content info.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Size of the content info if it exists, 0 - otherwise.
 */
- (size_t)contentInfoSizeInData:(NSData * __nonnull)data error:(NSError * __nullable * __nullable)error;

/**
 Allows to set integer value for custom parameter name as a part of the content info in unencrypted form.

 @param value Value which have to be stored for parameter name given as a key.
 @param key String custom parameter name. The same parameter name can be used also for:
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)setInt:(int)value forKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Gets integer value for custom parameter name which has been set earlier.

 @param key String custom parameter name.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Value for given parameter name. In case of error returns 0 and `NSError` in error parameter.
 */
- (int)intForKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Removes int value for custom parameter which has been set earlier.

 @param key String custom parameter name. If there is no given int parameter present - just does nothing and returns `YES`.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)removeIntForKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Allows to set string value for custom parameter name as a part of the content info in unencrypted form.

 @param value String value which have to be stored for parameter name given as a key.
 @param key String custom parameter name. The same parameter name can be used also for:
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)setString:(NSString * __nonnull)value forKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Gets string value for custom parameter name which has been set earlier.

 @param key String custom parameter name.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return String value for given parameter name. In case of error returns `nil` and `NSError` in error parameter.
 */
- (NSString * __nullable)stringForKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Removes string value for custom parameter which has been set earlier.

 @param key String custom parameter name. If there is no given string parameter present - just does nothing and returns `YES`.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)removeStringForKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Allows to set data value for custom parameter name as a part of the content info in unencrypted form.

 @param value Data value which have to be stored for parameter name given as a key.
 @param key String custom parameter name. The same parameter name can be used also for:
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)setData:(NSData * __nonnull)value forKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Gets data value for custom parameter name which has been set earlier.

 @param key String custom parameter name.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Data value for given parameter name. In case of error returns `nil` and `NSError` in error parameter.
 */
- (NSData * __nullable)dataForKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Removes data value for custom parameter which has been set earlier.

 @param key String custom parameter name. If there is no given data parameter present - just does nothing and returns `YES`.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)removeDataForKey:(NSString * __nonnull)key error:(NSError * __nullable * __nullable)error;

/**
 Checks if there are any custom parameters set.

 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `NO` in case there is no any parameter. `YES` - otherwise. In case of error - returns `YES` and `NSError` object in error parameter.
 */
- (BOOL)isEmptyCustomParametersWithError:(NSError * __nullable * __nullable)error;

/**
 Removes all custom parameters.

 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)clearCustomParametersWithError:(NSError * __nullable * __nullable)error;

@end
