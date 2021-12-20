require 'erb'
require 'time'
require './app/lib/pet_methods'

class Animal
  include PetMethods

  def self.call(env)
    new(env).response.finish
  end

  def response
    case @request.path
    when '/'
      Rack::Response.new(render('index.html.erb'))
    when '/initialize'
      Rack::Response.new do |r|
        r.set_cookie('energy', @energy)
        r.set_cookie('asleep', @asleep)
        r.set_cookie('lives', @lives)
        r.set_cookie('birth_time', @birth_time)
        r.set_cookie('name', @request.params['name'])
        r.redirect('/play')
      end

    when '/play'
      return PetMethods.rave_params(@request, 'rave') if @request.params['rave']
      return PetMethods.sleep_params(@request, 'sleep') if @request.params['sleep']
      return PetMethods.eat_params(@request, 'eat') if @request.params['eat']
      return PetMethods.bath_params(@request, 'bath') if @request.params['bath']
      return PetMethods.pet_params(@request, 'pet') if @request.params['pet']

      Rack::Response.new(render('play.html.erb'))
    when '/exit'
      Rack::Response.new('The End', 404)
      Rack::Response.new(render('exit.html.erb'))
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def name
    name = @request.cookies['name'].delete(' ')
    name.empty? ? 'Animal' : @request.cookies['name']
  end

  def get(attr)
    @request.cookies[attr.to_s].to_i
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    #@name = name
    @asleep = false
    @stuff_in_belly = 10
    @stuff_in_intestine = 0
    @lives = 10
    @energy = 10
    @birth_time = Time.new
    $COMMANDS = %w[rave rest eat pet age exit bath]
  end

  private

  def pet_age
    age = Time.now - @birth_time
    p age
  end
end
