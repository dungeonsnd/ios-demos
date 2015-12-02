
#ifndef _HEADER_FILE_WANCRYPTO_AES_H_
#define _HEADER_FILE_WANCRYPTO_AES_H_

#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    // calculate encrypted length by source length.
    size_t wcp_aes_get_encrypt_dst_len(size_t srcLen);

    // get the key length.
    const size_t wcp_aes_get_key_len();

    // get the iv length.
    const size_t wcp_aes_get_iv_len();
    
    // encrypt
    // dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
    int wcp_aes_encrypt(const char * in_src, size_t in_srcLen, 
                    char * out_dst, 
                    const char * in_key,
                    char * out_iv);
    
    // decrypt
    // dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
    int wcp_aes_decrypt(const char * in_src, size_t in_srcLen, 
                    char * out_dst, 
                    const char * in_key,
                    const char * in_iv);
    
#ifdef __cplusplus
}
#endif

#endif // _HEADER_FILE_WANCRYPTO_AES_H_
