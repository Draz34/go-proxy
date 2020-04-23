# proxy

A small TCP proxy written in Go

This project was intended for debugging text-based protocols. The next version will address binary protocols.

## Install

**Binaries**

Download [the latest release](https://github.com/Draz34/go-proxy/releases/latest)

**Source**

``` sh
$ go get -v github.com/Draz34/go-proxy/cmd/proxy
```

## Usage

```
$ proxy --help
Usage of proxy:
  -c: output ansi colors
  -h: output hex
  -l="localhost:9999": local address
  -n: disable nagles algorithm
  -r="localhost:80": remote address
  -match="": match regex (in the form 'regex')
  -replace="": replace regex (in the form 'regex~replacer')
  -v: display server actions
  -vv: display server actions and all tcp data
```

*Note: Regex match and replace*
**only works on text strings**
*and does NOT work across packet boundaries*

### Simple Example

Since HTTP runs over TCP, we can also use `proxy` as a primitive HTTP proxy:

```
$ proxy -r echo.draz34.com:80
TCPProxying from localhost:9999 to echo.draz34.com:80
```

```
go run cmd/proxy/main.go -l 192.168.0.50:53 -r 192.168.0.254:53 -p udp
UDP PRoxying from 192.168.0.50:53 to 192.168.0.254:53
```

Then test with `curl`:

```
$ curl -H 'Host: echo.draz34.com' localhost:9999/foo
{
  "method": "GET",
  "url": "/foo"
  ...
}
```

### Match Example

```
$ proxy -r echo.draz34.com:80 -match 'Host: (.+)'
TCPProxying from localhost:9999 to echo.draz34.com:80
Matching Host: (.+)

#run curl again...

Connection #001 Match #1: Host: echo.draz34.com
```

### Replace Example

```
$ proxy -r echo.draz34.com:80 -replace '"ip": "([^"]+)"~"ip": "REDACTED"'
TCPProxying from localhost:9999 to echo.draz34.com:80
Replacing "ip": "([^"]+)" with "ip": "REDACTED"
```

```
#run curl again...
{
  "ip": "REDACTED",
  ...
```

*Note: The `-replace` option is in the form `regex~replacer`. Where `replacer` may contain `$N` to substitute in group `N`.*

### Todo

* Implement `tcpproxy.Conn` which provides accounting and hooks into the underlying `net.Conn`
* Verify wire protocols by providing `encoding.BinaryUnmarshaler` to a `tcpproxy.Conn`
* Modify wire protocols by also providing a map function
* Implement [SOCKS v5](https://www.ietf.org/rfc/rfc1928.txt) to allow for user-decided remote addresses

#### MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
