#ifndef _NDK_UPSTREAM_LIST_H_INCLUDED_
#define _NDK_UPSTREAM_LIST_H_INCLUDED_

#include <ngx_http.h>


typedef struct {
    ngx_array_t         *upstreams;
} ndk_http_main_conf_t;


#if (NDK_UPSTREAM_LIST_CMDS)

/* TODO : use the generated commands */

{
    ngx_string ("upstream_list"),
    NGX_HTTP_MAIN_CONF|NGX_HTTP_SRV_CONF|NGX_CONF_2MORE,
    ndk_upstream_list,
    0,
    0,
    NULL
},

#else

typedef struct {
    ngx_str_t       **elts;
    ngx_uint_t        nelts;
    ngx_str_t         name;
} ndk_upstream_list_t;


ndk_upstream_list_t *
ndk_get_upstream_list (ndk_http_main_conf_t *mcf, u_char *data, size_t len);
char *
ndk_upstream_list (ngx_conf_t *cf, ngx_command_t *cmd, void *conf);

#endif

#endif /* _NDK_UPSTREAM_LIST_H_INCLUDED_ */
