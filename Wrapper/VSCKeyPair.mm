//
//  VSCKeyPair.mm
//  VirgilFoundation
//
//  Created by Pavel Gorb on 2/3/15.
//  Copyright (c) 2015 VirgilSecurity, Inc. All rights reserved.
//

#import "VSCKeyPair.h"
#import <VirgilCrypto/virgil/crypto/VirgilByteArray.h>
#import <VirgilCrypto/virgil/crypto/VirgilKeyPair.h>

using virgil::crypto::VirgilByteArray;
using Type = virgil::crypto::VirgilKeyPair::Type;
using namespace virgil::crypto;

NSString *const kVSSKeyPairErrorDomain = @"VSSKeyPairErrorDomain";

@interface VSCKeyPair ()

@property (nonatomic, assign) VirgilKeyPair *keyPair;

@end

@implementation VSCKeyPair

@synthesize keyPair = _keyPair;

#pragma mark - Lifecycle

- (instancetype)initWithKeyPairType:(Type)keyPairType password:(NSString *)password {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    try {
        if (password.length == 0) {
            _keyPair = new VirgilKeyPair(VirgilKeyPair::generate(keyPairType));
        }
        else {
            std::string pwd = std::string(password.UTF8String);
            _keyPair = new VirgilKeyPair(VirgilKeyPair::generate(keyPairType, VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(pwd.data(), pwd.size())));
        }
    }
    catch(...) {
        _keyPair = NULL;
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    try {
        _keyPair = new VirgilKeyPair(VirgilKeyPair::generateRecommended());
    }
    catch(...) {
        _keyPair = NULL;
    }
    
    return self;
}

- (void)dealloc {
    if (_keyPair != NULL) {
        delete _keyPair;
        _keyPair = NULL;
    }
}

+ (VSCKeyPair *)ecNist192WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP192R1 password:password];
}

+ (VSCKeyPair *)ecNist224WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP224R1 password:password];
}

+ (VSCKeyPair *)ecNist256WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP256R1 password:password];
}

+ (VSCKeyPair *)ecNist384WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP384R1 password:password];
}

+ (VSCKeyPair *)ecNist521WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP521R1 password:password];
}

+ (VSCKeyPair *)ecBrainpool256WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_BP256R1 password:password];
}

+ (VSCKeyPair *)ecBrainpool384WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_BP384R1 password:password];
}

+ (VSCKeyPair *)ecBrainpool512WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_BP512R1 password:password];
}

+ (VSCKeyPair *)ecKoblitz192WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP192K1 password:password];
}

+ (VSCKeyPair *)ecKoblitz224WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP224K1 password:password];
}

+ (VSCKeyPair *)ecKoblitz256WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::EC_SECP256K1 password:password];
}

+ (VSCKeyPair *)rsa256WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::RSA_256 password:password];
}

+ (VSCKeyPair *)rsa512WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::RSA_512 password:password];
}

+ (VSCKeyPair *)rsa1024WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::RSA_1024 password:password];
}

+ (VSCKeyPair *)rsa2048WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::RSA_2048 password:password];
}

+ (VSCKeyPair *)rsa4096WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::RSA_4096 password:password];
}

+ (VSCKeyPair *)curve25519WithPassword:(NSString *)password {
    return (VSCKeyPair *)[[self alloc] initWithKeyPairType:Type::FAST_EC_X25519 password:password];
}

#pragma mark - Public class logic

- (NSData *)publicKey {
    if( self.keyPair == NULL ) {
        return [NSData data];
    }
    NSData *publicKey = nil;
    try {
        VirgilByteArray pkey = self.keyPair->publicKey();
        publicKey = [NSData dataWithBytes:pkey.data() length:pkey.size()];
    }
    catch(...) {
        publicKey = [NSData data];
    }
    return publicKey;
}

- (NSData *)privateKey {
    if( self.keyPair == NULL ) {
        return [NSData data];
    }
    
    NSData *privateKey = nil;
    try {
        VirgilByteArray pkey = self.keyPair->privateKey();
        privateKey = [NSData dataWithBytes:pkey.data() length:pkey.size()];
    }
    catch(...) {
        privateKey = [NSData data];
    }
    return privateKey;
}

+ (BOOL)isEncryptedPrivateKey:(NSData *)keyData {
    if (keyData.length == 0) {
        return NO;
    }
    
    bool isEncrypted = false;
    try {
        const unsigned char *data = static_cast<const unsigned char *>(keyData.bytes);
        isEncrypted = VirgilKeyPair::isPrivateKeyEncrypted(VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(data, [keyData length]));
    }
    catch(...) {
        isEncrypted = false;
    }

    return isEncrypted;

}

+ (BOOL)isPrivateKey:(NSData *)keyData matchesPassword:(NSString *)password {
    if (keyData.length == 0 || password.length == 0) {
        return NO;
    }
    
    bool isMatches = false;
    try {
        const unsigned char *data = static_cast<const unsigned char *>(keyData.bytes);
        std::string pwd = std::string(password.UTF8String);
        isMatches = VirgilKeyPair::checkPrivateKeyPassword(VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(data, [keyData length]), VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(pwd.data(), pwd.size()));
    }
    catch(...) {
        isMatches = false;
    }

    return isMatches;

}

+ (BOOL)isPublicKey:(NSData *)publicKeyData matchesPrivateKey:(NSData *)privateKeyData withPassword:(NSString *)password {
    if (publicKeyData.length == 0 || privateKeyData.length == 0) {
        return NO;
    }
    
    bool isMatches = false;
    try {
        const unsigned char *pubKeyData = static_cast<const unsigned char *>(publicKeyData.bytes);
        const unsigned char *privKeyData = static_cast<const unsigned char *>(privateKeyData.bytes);
        if (password.length == 0) {
            isMatches = VirgilKeyPair::isKeyPairMatch(VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(pubKeyData, [publicKeyData length]), VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(privKeyData, [privateKeyData length]));
        }
        else {
            std::string pwd = std::string(password.UTF8String);
            isMatches = VirgilKeyPair::isKeyPairMatch(VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(pubKeyData, [publicKeyData length]), VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(privKeyData, [privateKeyData length]), VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(pwd.data(), pwd.size()));
        }
    }
    catch(...) {
        isMatches = false;
    }

    return isMatches;

}

+ (NSData * __nullable)resetPassword:(NSString *)password toPassword:(NSString *)newPassword forPrivateKey:(NSData *)keyData error:(NSError **)error {
    if (password.length == 0 || newPassword.length == 0 || keyData.length == 0) {
        // Can't reset password.
        if (error) {
            *error = [NSError errorWithDomain:kVSSKeyPairErrorDomain code:-1000 userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"Impossible to reset password: Required parameter is missing.", @"Reset password error.") }];
        }
        return nil;
    }
    
    NSData *pkeyData = nil;
    try {
        std::string sPwd = std::string(password.UTF8String);
        VirgilByteArray vbaPwd = VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(sPwd.data(), sPwd.size());
        
        std::string sNewPwd = std::string(newPassword.UTF8String);
        VirgilByteArray vbaNewPwd = VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(sNewPwd.data(), sNewPwd.size());
        
        const unsigned char *pKeyData = static_cast<const unsigned char *>(keyData.bytes);
        VirgilByteArray pKey = VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(pKeyData, [keyData length]);
        
        VirgilByteArray pNewKey = VirgilKeyPair::resetPrivateKeyPassword(pKey, vbaPwd, vbaNewPwd);
        pkeyData = [NSData dataWithBytes:pNewKey.data() length:pNewKey.size()];
        if (error) {
            *error = nil;
        }
    }
    catch(std::exception &ex) {
        if (error) {
            NSString *description = [[NSString alloc] initWithCString:ex.what() encoding:NSUTF8StringEncoding];
            if (description.length == 0) {
                description = @"Unknown exception during password reset.";
            }
            *error = [NSError errorWithDomain:kVSSKeyPairErrorDomain code:-1001 userInfo:@{ NSLocalizedDescriptionKey: description }];
        }
        pkeyData = nil;
    }
    catch(...) {
        if (error) {
            *error = [NSError errorWithDomain:kVSSKeyPairErrorDomain code:-1002 userInfo:@{ NSLocalizedDescriptionKey: @"Unknown exception during password reset." }];
        }
        pkeyData = nil;
    }
    
    return pkeyData;
}

@end