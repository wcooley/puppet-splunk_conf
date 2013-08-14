# == Define:: splunk_conf::inputs::monitor
#
# Manages Splunk monitor inputs.
#
# == Parameters
#
# [*namevar*]
#   Fully-qualified path of file to monitor. Note that unlike the top-level
#   +splunk_conf+ define, this is just the path to the file without the
#   "monitor:///" part.
#
# [*inputs_conf*]
#   Path to config file to manipulate. Defaults to
#   +/opt/splunk/etc/system/local/inputs.conf+.
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
# splunk_conf::inputs::monitor { '/foo/bar/baz.log':
#   set          => {
#     sourcetype => 'foo'
#   }
# }
#
# splunk_conf::inputs::monitor { '/foo/bar/baz.log':
#   ensure => 'absent',
# }
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
define splunk_conf::inputs::monitor (
    $set = undef,
    $rm = undef,
    $ensure = 'present',
    $inputs_conf = '/opt/splunk/etc/system/local/inputs.conf'
  ) {

  $file_monitor = "monitor://${title}"

  splunk_conf { $file_monitor:
    ensure      => $ensure,
    config_file => $inputs_conf,
    set         => $set,
    rm          => $rm,
  }

}
