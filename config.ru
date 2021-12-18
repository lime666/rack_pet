require './app/animal'

use Rack::Reloader, 0
use Rack::Static, :urls => ["/views"]

run Animal