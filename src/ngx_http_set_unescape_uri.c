#ifndef DDEBUG
#define DDEBUG 0
#endif
#include "ddebug.h"

#include "ndk_set_var.h"
#include "ngx_http_set_unescape_uri.h"

#ifndef NGX_UNESCAPE_URI_COMPONENT
#define NGX_UNESCAPE_URI_COMPONENT 0
#endif


ngx_int_t
ngx_http_set_misc_unescape_uri(ngx_http_request_t *r, ngx_str_t *res,
    ngx_http_variable_value_t *v)
{
    size_t                   len;
    u_char                  *p;
    u_char                  *src, *dst;

    /* the unescaped string can only be smaller */
    len = v->len;

    p = ngx_palloc(r->pool, len);
    if (p == NULL) {
        return NGX_ERROR;
    }

    src = v->data; dst = p;

    ngx_unescape_uri(&dst, &src, v->len, NGX_UNESCAPE_URI_COMPONENT);

    if (src != v->data + v->len) {
        ngx_log_error(NGX_LOG_ERR, r->connection->log, 0,
                      "set_unescape_uri: input data not consumed completely");
        return NGX_ERROR;
    }

    res->data = p;
    res->len = dst - p;

    return NGX_OK;
}
