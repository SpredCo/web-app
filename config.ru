root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )

$stdout.sync = true
run Spred.new
