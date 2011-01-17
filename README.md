# ProxyLocal

ProxyLocal could proxy your local web-server and make it publicly
available over the internet.

This software is splited into client and server parts. Server part is
running on [proxylocal.com] server and usage of its resources is free.
Client is written in ruby and distributed as gem, its source code is
open and available on [github].

## Installation

ProxyLocal is a tool that runs on the command line.

On any system with [ruby] and [rubygems] installed, open your terminal
and type:

    $ gem install proxylocal

## Usage

Assume you are running your local web-server on port 3000. To make it
publicly available run:

    $ proxylocal 3000
    Local server on port 3000 is now publicly available via:
    http://fp9k.t.proxylocal.com/

Now you can open this link in your favorite browser and request will
be proxied to your local web-server.

Also you can specify preferred host you want to use, e.g.:

    $ proxylocal 3000 --host testhost
    Local server on port 3000 is now publicly available via:
    http://testhost.t.proxylocal.com/

[proxylocal.com]: http://proxylocal.com/
[ruby]: http://www.ruby-lang.org/en/downloads/
[rubygems]: https://rubygems.org/pages/download
[github]: https://github.com/proxylocal/proxylocal-gem
