# vi:filetype=

use lib 'lib';
use Test::Nginx::Socket;

#repeat_each(3);

plan tests => repeat_each() * 2 * blocks();

no_long_string();

run_tests();

#no_diff();

__DATA__

=== TEST 1: hmac_sha1
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set $secret 'thisisverysecretstuff';
        set $string_to_sign 'some string we want to sign';
        set_hmac_sha1 $signature $secret $string_to_sign;
        set_encode_base64 $signature $signature;
        echo $signature;
    }
--- request
    GET /bar
--- response_body
R/pvxzHC4NLtj7S+kXFg/NePTmk=



=== TEST 2: hmac_sha1 empty vars
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set $secret '';
        set $string_to_sign '';
        set_hmac_sha1 $signature $secret $string_to_sign;
        set_encode_base64 $signature $signature;
        echo $signature;
    }
--- request
    GET /bar
--- response_body
+9sdGxiqbAgyS31ktx+3Y3BpDh0=



=== TEST 3: hmac_sha256
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set $secret 'thisisverysecretstuff';
        set $string_to_sign 'some string we want to sign';
        set_hmac_sha256 $signature $secret $string_to_sign;
        set_encode_base64 $signature $signature;
        echo $signature;
    }
--- request
    GET /bar
--- response_body
4pU3GRQrKKIoeLb9CqYsavHE2l6Hx+KMmRmesU+Cfrs=



=== TEST 4: hmac_sha256 empty vars
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set $secret '';
        set $string_to_sign '';
        set_hmac_sha256 $signature $secret $string_to_sign;
        set_encode_base64 $signature $signature;
        echo $signature;
    }
--- request
    GET /bar
--- response_body
thNnmggU2ex3L5XXeMNfxf8Wl8STcVZTxscSFEKSxa0=
