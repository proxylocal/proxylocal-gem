# ProxyLocal

ProxyLocal proxies your local web-server and makes it publicly
available over the internet.

This software is split into client and server parts. The server part is
running on [proxylocal.com] server and usage of its resources is free.
The client is written in ruby and distributed as gem. Its source code is
open and available on [github].

## Installation

ProxyLocal is a tool that runs on the command line.

On any system with [ruby] and [rubygems] installed, open your terminal
and type:

    $ gem install proxylocal

## Usage

I assume that you are running your local web-server on port 3000. To make it
publicly available run:

    $ proxylocal 3000
    Local server on port 3000 is now publicly available via:
    http://fp9k.t.proxylocal.com/

Now you can open this link in your favorite browser and request will
be proxied to your local web-server.

Also you can specify the preferred host you want to use, e.g.:

    $ proxylocal 3000 --host testhost
    Local server on port 3000 is now publicly available via:
    http://testhost.t.proxylocal.com/

[proxylocal.com]: http://proxylocal.com/
[ruby]: http://www.ruby-lang.org/en/downloads/
[rubygems]: https://rubygems.org/pages/download
[github]: https://github.com/proxylocal/proxylocal-gem
