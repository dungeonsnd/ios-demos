    
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#include <math.h>
#include <sys/time.h>

#include "openssl/aes.h"
#include "openssl/rand.h"

size_t wcp_aes_get_encrypt_dst_len(size_t srcLen)
{
    double d =(ceil)( (double)srcLen/AES_BLOCK_SIZE ) ;
#ifdef DEBUG            
            fprintf(stderr, "srcLen=%d , d=%f\n", 
                (int)srcLen,
                d);
#endif
    return (size_t) d* AES_BLOCK_SIZE;
}

const size_t wcp_aes_get_key_len()
{
    return AES_BLOCK_SIZE*2;
}

// get the iv length.
const size_t wcp_aes_get_iv_len()
{
    return 16;
}

// dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
int wcp_aes_encrypt(const char * src, size_t srcLen, 
    char * dst,
    const char * key,
    char * iv) {

    int ret =-1;
    do {

        const size_t key_space =wcp_aes_get_key_len();
        size_t dstLen =wcp_aes_get_encrypt_dst_len(srcLen);

        AES_KEY aes;
        
        if (src == NULL || dst == NULL ||key == NULL ) {
#ifdef DEBUG            
            fprintf(stderr, "src == NULL || dst == NULL ||key == NULL \n");
#endif
            ret =-2;
            break;
        }
    
        //set IV.
        long timev =srcLen;
        {
            struct timeval tv;
            struct timezone tz;
            gettimeofday (&tv , &tz);
            timev =timev+tv.tv_sec+tv.tv_usec;
        }
        RAND_seed(&timev,(int)sizeof(timev));
         // careful, don't use sizeof(iv) bcz of iv is ptr whe in functions parameters.
        const wcp_iv_len =wcp_aes_get_iv_len();
        RAND_bytes(iv, wcp_iv_len);
        memset(iv,0,wcp_iv_len);

        int rt =AES_set_encrypt_key((const unsigned char *)key, key_space*8, &aes);
        if ( rt< 0) {
#ifdef DEBUG            
            fprintf(stderr, "Unable to set encryption key in AES, rt=%d, key_space=%d \n", 
                rt, (int)key_space);
#endif
            ret =-3;
            break;
        }
        
        if (srcLen!=dstLen)
        {
            // set the input string
            char * in= (char*)calloc(dstLen, sizeof(unsigned char));
            if (in == NULL) 
            {
#ifdef DEBUG           
                fprintf(stderr, "Unable to allocate memory for in\n");
#endif
                ret =-4;
                break;
            }
            // padding.
            memset(in, 0, dstLen); 
            // copy src to in.
            memcpy(in, (void *)src, srcLen);
            // encrypt (iv will change)
            // src len must equal dst len.
            char tmp_iv[wcp_iv_len];
            memcpy(tmp_iv, iv, sizeof(tmp_iv));
            AES_cbc_encrypt((const unsigned char *)in, (unsigned char *)dst, dstLen, &aes, tmp_iv, AES_ENCRYPT);
            free(in);
        }
        else
        {
            // encrypt (iv will change)
            // src len must equal dst len.
            char tmp_iv[wcp_iv_len];
            memcpy(tmp_iv, iv, sizeof(tmp_iv));
            AES_cbc_encrypt((const unsigned char *)src, (unsigned char *)dst, dstLen, &aes, tmp_iv, AES_ENCRYPT);
        }


#ifdef DEBUG        
        // print
        fprintf(stderr, "encrypt key=");
        for (size_t i=0; i<key_space; ++i) {
            fprintf(stderr, "%02x ", (unsigned char)(0xFF && key[i]) );    
        }
        fprintf(stderr, "\nsrc=");
        for (size_t i=0; i<srcLen; ++i) {
            fprintf(stderr, "%02x ", (unsigned char)(0xFF && src[i]) );    
        }
        fprintf(stderr, "\ndst=");
        for (size_t i=0; i<dstLen; ++i) {
            fprintf(stderr, "%02x ", (unsigned char)(0xFF && dst[i]) );    
        }
        fprintf(stderr, "\n");
#endif

        ret =0;
    } while(0);
    return ret;
}


// dstLen can obtain by wcp_encrypt_len (in multiple of AES_BLOCK_SIZE).
int wcp_aes_decrypt(const char * src, size_t srcLen, 
    char * dst,
    const char * key,
    const char * in_iv) {

    int ret =-1;
    do {
        if (wcp_aes_get_encrypt_dst_len(srcLen)!=srcLen)
         {
#ifdef DEBUG            
            fprintf(stderr, "srcLen{%d} error! \n", (int)srcLen);
#endif
            ret =-2;
            break;
         } 

        const size_t key_space =wcp_aes_get_key_len();
        
        AES_KEY aes;
        
        if (src == NULL || dst == NULL ||key == NULL) {
#ifdef DEBUG            
            fprintf(stderr, "src == NULL || dst == NULL ||key == NULL \n");
#endif
            ret =-3;
            break;
        }
        
        if (AES_set_decrypt_key((const unsigned char *)key, key_space*8, &aes) < 0) {
#ifdef DEBUG            
            fprintf(stderr, "Unable to set decryption key in AES\n");
#endif
            ret =-4;
            break;
        }
        
#ifdef DEBUG            
        fprintf(stderr, "decrypt key=");
        for (size_t i=0; i<key_space; ++i) {
            fprintf(stderr,  "%02x ", (unsigned char)(0xFF && key[i]) );    
        }
#endif

        // decrypt
        // src len must equal dst len.
        const wcp_iv_len =wcp_aes_get_iv_len();
        char tmp_iv[wcp_iv_len];
        memcpy(tmp_iv, in_iv, sizeof(tmp_iv));
        AES_cbc_encrypt((const unsigned char *)src, (unsigned char *)dst, srcLen, &aes, tmp_iv, AES_DECRYPT);
        
        ret =0;
    } while(0);
    return ret;
}
