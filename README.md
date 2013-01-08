Description
===========

Installs gitolite, and optionally adds a daily rsync and weekly tar.gz backup to a nice backup location.

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

Installs gitolite, and optionally adds a daily rsync and weekly tar.gz backup to a nice backup location. 

Usage
=====

    include_recipe "gitolite"
    include_recipe "gitolite::backup"

    Or if you'd like to use a role, as I do:

    {
      "name": "gitolite",
      "default_attributes": {
      },
      "json_class": "Chef::Role",
      "env_run_lists": {
      },
      "run_list": [
        "recipe[gitolite]",
        "recipe[gitolite::backup]"
      ],
      "description": "This is gitolite role!",
      "chef_type": "role",
      "override_attributes": {
        "gitolite": {
          "backup_device": "nfs_server:/exports/backups/git"
        }
      }
    }



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

