

#import <Foundation/Foundation.h>

@interface WCrypto : NSObject

+ (NSInteger)encrypt:(NSData *)src
         blockSucess:(void(^)(NSData *result, NSData *iv))cbSucess
        blockFailure:(void(^)(NSInteger reason))cbFailure;

+ (NSInteger)decrypt:(NSData *)src
                  iv:(NSData *)iv
         blockSucess:(void(^)(NSData *result))cbSucess
        blockFailure:(void(^)(NSInteger reason))cbFailure;

@end
