

#include "wancrypto_aes.h"


// dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
int wcp_pic_encrypt(const char * src, size_t srcLen, 
    char * dst,
    const char * key,
    char * iv) {
    return wcp_aes_encrypt(src, srcLen, dst, key, iv);
}


// dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
int wcp_pic_decrypt(const char * src, size_t srcLen, 
    char * dst,
    const char * key,
    const char * in_iv) {
    return wcp_aes_decrypt(src, srcLen, dst, key, in_iv);
}


