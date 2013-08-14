# == Define: splunk_conf
#
# Manages Splunk's ini-file style configuration files.
#
# === Parameters
#
# [*namevar*]
#   Name of section in ini-file.
#
# [*config_file*]
#   *Required* Path to config file to manipulate.
#
# [*ensure*]
#   Choices are 'absent' and 'present'. Set to 'absent' to remove the section
#   entirely. Defaults to 'present'.
#
# [*set*]
#   Hash of section parameters and values. Note that as a hash, the order is
#   non-deterministic.
#
# [*rm*]
#   Array of section parameters to remove.
#
# === Examples
#
#   splunk_conf { 'monitor:///foo/bar/baz.log':
#     config_file  => '/opt/splunkforwarder/etc/system/local/inputs.conf',
#     set          => {
#       sourcetype => 'foo',
#     },
#     rm => [ 'disabled' ],
#   }
#
#   splunk_conf { 'monitor:///foo/bar/baz.log':
#     config_file => '/opt/splunkforwarder/etc/system/local/inputs.conf',
#     ensure      => 'absent',
#   }
#
# === Authors
#
# Wil Cooley <wcooley@nakedape.cc>
#
# === Copyright
#
# Copyright (C)2013 Will R. (Wil) Cooley
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
define splunk_conf (
    $config_file,
    $set = {},
    $rm = [],
    $ensure = 'present'
  ) {

  case $ensure {
    'present': {
      $changes = flatten([
        "defnode target target[. = '${title}'] ${title}",
        prefix(join_keys_to_values($set, ' '), 'set $target/'),
        prefix($rm, 'rm $target/'),
      ])
    }
    'absent': {
      $changes = "rm target[. = '${title}']"
    }
    default: {
      fail("status=unrecognized_value name=ensure value=\"${ensure}\"")
    }
  }

  #notice("\nchanging config: ${config_file}")
  #$changes_print = join(flatten([$changes]), "\n")
  #notice("\$changes:\n${changes_print}")

  augeas { "splunk_conf-${title}":
    lens    => 'Splunk.lns',
    incl    => $config_file,
    changes => $changes,
  }

}
