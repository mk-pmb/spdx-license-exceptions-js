
<!--#echo json="package.json" key="name" underline="=" -->
spdx-license-exceptions
=======================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Lookup SPDX license exception identifiers.
<!--/#echo -->

Main purpose of this module is to centralize efforts for URL template
maintaince and anomaly handling.


NO SPDX DATA INCLUDED
---------------------

I'm trying to obtain a license to reproduce the actual table data.
Until then, you'll have to scrape it yourself by running `upd.sh`.



API
---

  * `lice(name)`: Try to find info on the license exception `name`
    specified as a string.
    If found, return that info as a JS object, else return `false`.
  * `lice.orThrow(name)`: Like `lice(name)` but on failure, throw an error
    instead of returning `false`.
  * `licu.spdxVersions`: The list versions of lookup tables used.


Usage
-----

Use it indirectly via the `spdx-license-exceptions` module.


<!--#toc stop="scan" -->


License
-------

<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
