#ifndef DDEBUG
#define DDEBUG 0
#endif
#include "ddebug.h"

#include <ndk.h>

#include "ngx_http_set_hmac.h"
#include <openssl/evp.h>
#include <openssl/hmac.h>


/* this function's implementation is partly borrowed from
 * https://github.com/anomalizer/ngx_aws_auth */
static ngx_int_t
ngx_http_set_misc_set_hmac(ngx_http_request_t *r, ngx_str_t *res,
    ngx_http_variable_value_t *v, const EVP_MD *evp_md)
{
    ngx_http_variable_value_t   *secret, *string_to_sign;
    unsigned int                 md_len = 0;
    unsigned char                md[EVP_MAX_MD_SIZE];

    secret = v;
    string_to_sign = v + 1;

    dd("secret=%.*s, string_to_sign=%.*s", (int) secret->len, secret->data,
       (int) string_to_sign->len, string_to_sign->data);

    HMAC(evp_md, secret->data, secret->len, string_to_sign->data,
         string_to_sign->len, md, &md_len);

    /* defensive test if there is something wrong with openssl */
    if (md_len == 0 || md_len > EVP_MAX_MD_SIZE) {
        res->len = 0;
        return NGX_ERROR;
    }

    res->len = md_len;
    res->data = ngx_palloc(r->pool, md_len);
    if (res->data == NULL) return NGX_ERROR;

    ngx_memcpy(res->data,
               &md,
               md_len);

    return NGX_OK;
}


ngx_int_t
ngx_http_set_misc_set_hmac_sha1(ngx_http_request_t *r, ngx_str_t *res,
    ngx_http_variable_value_t *v)
{
    return ngx_http_set_misc_set_hmac(r, res, v, EVP_sha1());
}


ngx_int_t
ngx_http_set_misc_set_hmac_sha256(ngx_http_request_t *r, ngx_str_t *res,
    ngx_http_variable_value_t *v)
{
    return ngx_http_set_misc_set_hmac(r, res, v, EVP_sha256());
}
