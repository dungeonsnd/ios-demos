//
//  OpensslWrapper.m
//

#import "WCrypto.h"
#include "wancrypto_aes.h"


@implementation WCrypto

+ (NSInteger)encrypt:(NSData *)src
         blockSucess:(void(^)(NSData *result, NSData *iv))cbSucess
        blockFailure:(void(^)(NSInteger reason))cbFailure{
    NSInteger rs =-1;
    do {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int rt =0;
            NSData *dst;
            NSData *out_iv;
            
            // calculate encrypted length by source length.
            size_t dst_len =wcp_aes_get_encrypt_dst_len([src length]);            
            
            // get the key length.
            const size_t key_len =wcp_aes_get_key_len();
            char key[key_len];
            memset(key, 'a', key_len);
            
            char iv_c_str[wcp_aes_get_iv_len()];
            
            // encrypt
            // dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
            const char * src_c_str =(const char * )[src bytes];
            char * dst_c_str =(char *)malloc(dst_len);
            rt =wcp_aes_encrypt(src_c_str, [src length],
                                dst_c_str,
                                key,
                                iv_c_str);
            if (0==rt) {
                dst =[NSData dataWithBytes:dst_c_str length:dst_len];
                out_iv =[NSData dataWithBytes:iv_c_str length:sizeof(iv_c_str)];
            }
            free(dst_c_str);
            
            if (0==rt) {
                if (cbSucess) {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        cbSucess(dst, out_iv);
                    });
                }
            }
            else {
                if (cbFailure) {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        cbFailure(rt);
                    });
                }
            }
        });
        
        rs =0;
    }while (0);
    return rs;
}


+ (NSInteger)decrypt:(NSData *)src
                  iv:(NSData *)iv
         blockSucess:(void(^)(NSData *result))cbSucess
        blockFailure:(void(^)(NSInteger reason))cbFailure{
    NSInteger rs =-1;
    do {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int rt =0;
            NSData *dst;
            
            if ([iv length]==wcp_aes_get_iv_len()) {
                // get the key length.
                const size_t key_len =wcp_aes_get_key_len();
                char key[key_len];
                memset(key, 'a', key_len);
                
                // encrypt
                const char * src_c_str =(const char * )[src bytes];
                const char * iv_c_str =(const char *)[iv bytes];
                char * dst_c_str =(char *)malloc([src length]);
                rt =wcp_aes_decrypt(src_c_str, [src length],
                                    dst_c_str,
                                    key,
                                    iv_c_str);
                if (0==rt) {
                    dst =[NSData dataWithBytes:dst_c_str length:[src length]];
                }
                free(dst_c_str);
            }
            else
            {
                rt =-100;
            }
            
            if (0==rt) {
                if (cbSucess) {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        cbSucess(dst);
                    });
                }
            }
            else {
                if (cbFailure) {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        cbFailure(rt);
                    });
                }
            }
        });
        
        rs =0;
    }while (0);
    return rs;
}

@end
