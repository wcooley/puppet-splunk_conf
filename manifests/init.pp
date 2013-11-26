# == Define: splunk_conf
#
# Manages Splunk's ini-file style configuration files.
#
# === Parameters
#
# [*namevar*]
#   The title of the resource. If *stanza* is not given, the *namevar* is used
#   instead.
#
# [*stanza*]
#   Name of section in ini-file. Generally *namevar* should be the stanza, but
#   to manage the same stanza in multiple files, the *namevar* can be abstract
#   and unique.  Defaults to *namevar*.
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
#   splunk_conf { 'baz.log':
#     config_file  => '/opt/splunkforwarder/etc/system/local/inputs.conf',
#     stanza       => 'monitor:///foo/bar/baz/log',
#     set          => {
#       sourcetype => 'foo',
#     },
#     rm => [ 'disabled' ],
#   }
#
#   splunk_conf { 'baz.log':
#     config_file => '/opt/splunkforwarder/etc/system/local/inputs.conf',
#     stanza       => 'monitor:///foo/bar/baz/log',
#     ensure      => 'absent',
#   }
#
#   splunk_conf { 'server_splunkd_settings':
#     config_file    => '/opt/splunk/etc/system/local/web.conf',
#     stanza         => 'settings',
#     set            => {
#       mgmtHostPort => '127.0.0.1:18089',
#     }
#     ensure      => 'present',
#   }
#
# === Authors
#
# Wil Cooley <wcooley@nakedape.cc>
#  with modifications by Alex Scoble <itblogger@gmail.com>
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
    $stanza = undef,
    $set = {},
    $rm = [],
    $ensure = 'present'
  ) {

  $real_stanza = $stanza ? { undef => $name, default => $stanza }

  case $ensure {
    'present': {
      $changes = flatten([
        "defnode target target[. = '${real_stanza}'] ${real_stanza}",
        prefix(sort(join_keys_to_values($set, ' ')), 'set $target/'),
        prefix($rm, 'rm $target/'),
      ])
    }
    'absent': {
      $changes = "rm target[. = '${real_stanza}']"
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
