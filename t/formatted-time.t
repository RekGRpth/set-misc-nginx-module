# vi:filetype=

use lib 'lib';
use Test::Nginx::Socket;
use POSIX qw(strftime);

my $fmt="%a %b %e %H:%M:%S %Y";

our $str_local = (strftime $fmt, localtime  time()).'|'.(strftime $fmt, localtime time()+1).'|'.(strftime $fmt, localtime time()+2);

our $str_gmt =  (strftime $fmt, gmtime time()).'|'.(strftime $fmt, gmtime time()+1).'|'.(strftime $fmt, gmtime time()+2);

repeat_each(2);

plan tests => repeat_each() * 2 * blocks();

log_level('warn');

run_tests();

#no_diff();

__DATA__

=== TEST 1: local time format
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /foo {
        set_formatted_local_time $today "%a %b %e %H:%M:%S %Y";
        echo $today;
    }
--- request
GET /foo
--- response_body_like eval: $main::str_local



=== TEST 2: GMT time format
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set_formatted_gmt_time $today "%a %b %e %H:%M:%S %Y";
        echo $today;
    }
--- request
GET /bar
--- response_body_like eval: $main::str_gmt



=== TEST 3: set_formatted_gmt_time (empty formatter)
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set_formatted_gmt_time $today "";
        echo "[$today]";
    }
--- request
GET /bar
--- response_body
[]



=== TEST 4: set_formatted_local_time (empty formatter)
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set_formatted_local_time $today "";
        echo "[$today]";
    }
--- request
GET /bar
--- response_body
[]



=== TEST 5: set_formatted_local_time (constant formatter)
--- main_config
    load_module /etc/nginx/modules/ndk_http_module.so;
    load_module /etc/nginx/modules/ngx_http_echo_module.so;
    load_module /etc/nginx/modules/ngx_http_set_misc_module.so;
--- config
    location /bar {
        set_formatted_local_time $today "hello world";
        echo "[$today]";
    }
--- request
GET /bar
--- response_body
[hello world]
