# vi:filetype=perl

use lib 'lib';
use Test::Nginx::Socket;

#repeat_each(3);

plan tests => repeat_each() * 2 * blocks();

no_long_string();

run_tests();

#no_diff();

__DATA__

=== TEST 1: set quote json value
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /foo {
        set $foo "hello\n\r'\"\\";
        set_quote_json_str $foo $foo;
        echo $foo;
    }
--- request
GET /foo
--- response_body
"hello\n\r'\"\\"



=== TEST 2: set quote json value (in place)
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /foo {
        set $foo "hello\n\r'\"\\";
        set_quote_json_str $foo;
        echo $foo;
    }
--- request
GET /foo
--- response_body
"hello\n\r'\"\\"



=== TEST 3: set quote empty json value
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /foo {
        set $foo "";
        set_quote_json_str $foo;
        echo $foo;
    }
--- request
GET /foo
--- response_body
null



=== TEST 4: set quote null json value
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /foo {
        set_quote_json_str $foo;
        echo $foo;
    }
--- request
GET /foo
--- response_body
null
