root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )

$stdout = $stderr
run Spred.new
