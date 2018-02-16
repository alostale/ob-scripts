Scripts to anlyize `apache.log`.

They assume daily file rotatation and the following format: `"%h %l %u %t %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %>s %b %I %D \"%{Referer}i\" \"%{User-agent}i\""`


