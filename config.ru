require './app/animal'

use Rack::Reloader, 0
use Rack::Static, :urls => ["/views"]
use Rack::Auth::Basic do |username, password|
  password == "passwd"
end

run Animal