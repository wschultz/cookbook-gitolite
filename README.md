Description
===========

Installs gitolite3 "g3".
This will grab gitolite from the repository, install it, and set it up with a local user as admin. In the default configuration this would mean that you log into the box via any typical means and then sudo into the 'git' user. Then you would make changes inside the ~/gitolite-admin directory, and git push those changes.

Requirements
============

## Platform:

* Debian/Ubuntu

## Cookbooks:

###
* git

Recipes
=======

## default

Installs gitolite "g3" 

Usage
=====

    include_recipe "gitolite"

License and Author
==================

Author:: Wil Schultz

Copyright 2012

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

