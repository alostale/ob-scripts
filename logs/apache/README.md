Scripts to anlyize `apache.log`.

They assume daily file rotatation and the following format: `"%h %l %u %t %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %>s %b %I %D \"%{Referer}i\" \"%{User-agent}i\""`. 

Actual formatting can be checked at `/etc/apache2/sites-enabled/default-ssl.conf`.
