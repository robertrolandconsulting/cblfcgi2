# cblfcgi2

Code to experiment with how to interact with FastCGI properly

## socat was my friend

This set of commands let me inspect the UNIX socket output from
two FastCGI programs, my own and the `echo-x.c` sample from fcgi2
so I could look for differences in the communication between the
app and the webserver.

```bash
sudo mv /tmp/echo.socket-0 /tmp/echo.socket-0.original
sudo socat -t100 -x -v UNIX-LISTEN:/tmp/echo.socket-0,mode=777,reuseaddr,fork UNIX-CONNECT:/tmp/echo.socket-0.original
```

## License

MIT license.
