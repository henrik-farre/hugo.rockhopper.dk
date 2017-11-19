---
title: "Import Host and Group Vars Into AWX"
date: 2017-11-18T15:19:28Z
url: "/linux/software/import-host-and-group-vars-into-awx"
tags: ["AWX", "Ansible Tower"]
categories: [
  "software",
  "ansible",
  "awx"
]
---

Recently RedHat released [Ansible tower as open source](https://www.ansible.com/open-tower) as the [AWX project](https://github.com/ansible/awx/). So I've imported my local Ansible project into AWX, but manually importing alot of host and group vars can be a bit tedious.<!--more-->

Using [tower-cli](http://tower-cli.readthedocs.io/en/latest/) this can thankfully be automated.

To import all host vars in a directory, where each file is a FQDN matching the hostname in AWX, use:
{{< code bash >}}for FILE in $(find . -depth 1 -type f); do tower-cli host modify --variables @${FILE#\./} --name=${FILE#\./} -i 2; done{{< /code >}}

To do the same for groups:
{{< code bash >}}for FILE in $(find . -depth 1 -type f); do tower-cli group modify --variables @${FILE#\./} --name=${FILE#\./} -i 2; done{{< /code >}}

And you are done :)
