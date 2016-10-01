$session = {}
root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )
$app = Spred.new
run $app