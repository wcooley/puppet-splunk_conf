require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-augeas'

RSpec.configure do |c|
    c.augeas_fixtures = File.join(File.dirname(File.expand_path(__FILE__)),
                                  'fixtures', 'augeas')
    c.augeas_lensdir = File.join(File.dirname(File.expand_path(__FILE__)),
                                  '..', 'lib/augeas/lenses')
    ENV['AUGEAS_LENS_LIB'] = c.augeas_lensdir
end
