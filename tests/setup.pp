
$mod_path = get_module_path('splunk_conf')

Augeas {
  load_path => "${mod_path}/lib/augeas/lenses"
}
