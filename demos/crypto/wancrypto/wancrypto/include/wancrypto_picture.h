
#ifndef _HEADER_FILE_WANCRYPTO_PICTURE_H_
#define _HEADER_FILE_WANCRYPTO_PICTURE_H_


#ifdef __cplusplus
extern "C" {
#endif
    
    
    // encrypt
    // dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
    int wcp_encrypt(const char * in_src, size_t in_srcLen, 
                    char * out_dst, 
                    const char * in_key,
                    char * out_iv);
    
    // decrypt
    // dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
    int wcp_decrypt(const char * in_src, size_t in_srcLen, 
                    char * out_dst, 
                    const char * in_key,
                    const char * in_iv);
    
#ifdef __cplusplus
}
#endif

#endif // _HEADER_FILE_WANCRYPTO_PICTURE_H_

