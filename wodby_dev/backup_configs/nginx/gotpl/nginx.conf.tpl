user                            {{ getenv "NGINX_USER" "nginx" }};
daemon                          off;
worker_processes                {{ getenv "NGINX_WORKER_PROCESSES" "auto" }};
error_log                       /proc/self/fd/2 {{ getenv "NGINX_ERROR_LOG_LEVEL" "error" }};

events {
    worker_connections          {{ getenv "NGINX_WORKER_CONNECTIONS" "4096" }};
    multi_accept                {{ getenv "NGINX_MULTI_ACCEPT" "on" }};
}

http {
    include                     /etc/nginx/mime.types;
    default_type                application/octet-stream;

    log_format                  real_ip '$http_x_real_ip - $remote_user [$time_local] '
                                        '"$request" $status $body_bytes_sent '
                                        '"$http_referer" "$http_user_agent"';

    {{ if getenv "NGINX_LOG_FORMAT_OVERRIDE" }}
    log_format                  combined '{{ getenv "NGINX_LOG_FORMAT_OVERRIDE" }}';
    {{ end }}

    access_log                  /proc/self/fd/1 {{ if getenv "NGINX_LOG_FORMAT_SHOW_REAL_IP" }}real_ip{{ else }}combined{{ end }};

    send_timeout                {{ getenv "NGINX_SEND_TIMEOUT" "60s" }};
    sendfile                    {{ getenv "NGINX_SENDFILE" "on" }};
    client_body_timeout         {{ getenv "NGINX_CLIENT_BODY_TIMEOUT" "60s" }};
    client_header_timeout       {{ getenv "NGINX_CLIENT_HEADER_TIMEOUT" "60s" }};
    client_max_body_size        {{ getenv "NGINX_CLIENT_MAX_BODY_SIZE" "32m" }};
    client_body_buffer_size     {{ getenv "NGINX_CLIENT_BODY_BUFFER_SIZE" "16k" }};
    client_header_buffer_size   {{ getenv "NGINX_CLIENT_HEADER_BUFFER_SIZE" "4k" }};
    large_client_header_buffers {{ getenv "NGINX_LARGE_CLIENT_HEADER_BUFFERS" "8 16K" }};
    keepalive_timeout           {{ getenv "NGINX_KEEPALIVE_TIMEOUT" "75s" }};
    keepalive_requests          {{ getenv "NGINX_KEEPALIVE_REQUESTS" "100" }};
    reset_timedout_connection   {{ getenv "NGINX_RESET_TIMEDOUT_CONNECTION" "off" }};
    tcp_nodelay                 {{ getenv "NGINX_TCP_NODELAY" "on" }};
    tcp_nopush                  {{ getenv "NGINX_TCP_NOPUSH" "on" }};
    server_tokens               {{ getenv "NGINX_SERVER_TOKENS" "off" }};

    upload_progress             {{ getenv "NGINX_UPLOAD_PROGRESS" "uploads 1m" }};

    gzip                        {{ getenv "NGINX_GZIP" "on" }};
    gzip_buffers                {{ getenv "NGINX_GZIP_BUFFERS" "16 8k" }};
    gzip_comp_level             {{ getenv "NGINX_GZIP_COMP_LEVEL" "1" }};
    gzip_http_version           {{ getenv "NGINX_GZIP_HTTP_VERSION" "1.1" }};
    gzip_min_length             {{ getenv "NGINX_GZIP_MIN_LENGTH" "20" }};
    gzip_types                  text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript image/x-icon application/vnd.ms-fontobject font/opentype application/x-font-ttf;
    gzip_vary                   {{ getenv "NGINX_GZIP_VARY" "on" }};
    gzip_proxied                {{ getenv "NGINX_GZIP_PROXIED" "any" }};
    gzip_disable                {{ getenv "NGINX_GZIP_DISABLE" "msie6" }};

    {{ if not (getenv "NGINX_NO_DEFAULT_HEADERS") }}
    add_header                  X-XSS-Protection '1; mode=block';
    add_header                  X-Frame-Options SAMEORIGIN;
    add_header                  X-Content-Type-Options nosniff;
    {{ end }}

    map $uri $no_slash_uri {
        ~^/(?<no_slash>.*)$ $no_slash;
    }

    include {{ getenv "NGINX_CONF_INCLUDE" "conf.d/*.conf" }};

	add_header X-Country $http_cf_ipcountry;
}
