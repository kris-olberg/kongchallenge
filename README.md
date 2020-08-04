[![Build Status][badge-travis-image]][badge-travis-url]

Kong plugin
====================

This repository contains a Kong plugin intended to proxy to upstreams based
on custom header values in requests.

This work was based on a template at https://github.com/Kong/kong-plugin,
which was designed to work with the
[`kong-pongo`](https://github.com/Kong/kong-pongo) and
[`kong-vagrant`](https://github.com/Kong/kong-vagrant) development environments.

Most of the function code and schema was borrowed from the work done at 
https://github.com/murillopaula/kong-upstream-by-header.git.

Please check out those repos' `README` files for usage instructions.

[badge-travis-url]: https://travis-ci.org/Kong/kong-plugin/branches
[badge-travis-image]: https://travis-ci.com/Kong/kong-plugin.svg?branch=master
