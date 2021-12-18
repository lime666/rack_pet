require 'erb'
require 'time'
require './app/lib/pet_methods'

class Animal
  include Pet_Methods

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
        r.set_cookie('stuff_in_belly', @stuff_in_belly)
        r.set_cookie('stuff_in_intestine', @stuff_in_intestine)
        r.set_cookie('birth_time', @birth_time)
        r.set_cookie('name', @request.params['name'])
        r.redirect('/play')
      end

    when '/play'
      return Pet_Methods.rave_params(@request, 'rave') if @request.params['rave']
      return Pet_Methods.change_params(@request, 'rest') if @request.params['rest']
      return Pet_Methods.change_params(@request, 'eat') if @request.params['eat']
      return Pet_Methods.change_params(@request, 'bath') if @request.params['bath']
      return Pet_Methods.change_params(@request, 'status') if @request.params['status']
      return Pet_Methods.change_params(@request, 'pet') if @request.params['pet']
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
    @request.cookies["#{attr}"].to_i
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
    $COMMANDS = %w[eat rest rave wakeup pet bath wc voice help status age exit]
  end

  def eat
    if @stuff_in_belly <= 5 && @energy <= 5
      sleep 2
      p 'Спасибо, было очень вкусно, хотя я хз чем ты меня накормил.'
      p 'Теперь хочу тусить.'
      @energy += 2
      @stuff_in_belly += 3
      @stuff_in_intestine += 2
    else
      p 'Спасибо, я не голоден.'
    end
  end

  def rest
    p 'Вы укладываете животину спать.'
    @asleep = true
    @energy += 3
    time_to_pass
  end

  def rave
    p "Вы играете с #{@name}."
    @energy -= 2
    p 'Жизнь меня к такому не готовила, хозяин.' if @energy <= 6
    time_to_pass
    p 'Не любишь ты меня, хозяин. Помер я.' if death
  end

  def wakeup
    @asleep = false
    p 'За что, хозяин?'
    p 'Ну, раз ты меня рабудил..Чем займемя, милашка?'
  end

  def pet
    p "Вы чешите #{@name} пузико."
    @energy -= 1
    p 'ур-ур-ур '
    sleep 2
    p 'Спасибушки, хозяин. Я бы тоже хотел тебя почесать =)'
    time_to_pass
  end

  def bath
    p "#{@name} купется."
    @energy -= 1
    time_to_pass
  end

  def wc
    if @stuff_in_intestine >= 7
      p 'Жизнь обрела краски.'
      @stuff_in_intestine = 0
    else
      p 'Чуть позже, пожалуйста.'
    end
  end

  def voice
    p 'Во время линьки у некоторых птиц утрачивается способность к полету. '\
      'Так, например, утки при этом не могут летать 20-35 суток, '\
      'лебеди – почти 1,5 месяца.'
  end

  def help
    p 'eat - накормить'
    p 'rest - положить спать'
    p 'rave - поиграть'
    p 'repeat - повторить действие'
    p 'wakeup - разбудить'
    p 'pet - учить'
    p 'bath - купаться'
    p 'voice - животина что-то поведает'
    p 'wc - опорожнить кишечник'
    p 'help - помощь'
    p 'status - что происходит'
    p 'exit - выйти из игры'
  end

  def status
    p 'Зачем я живу? Даже покормить некому...' if hungry?
    p 'Где упал, там и кровать.' if want_to_sleep?
    p '...' if death
    p "#{@lives} - осталось жизней."\
      "#{@energy} - уровень бодрости."\
      "#{@stuff_in_belly} - уровень еды внутри."\
      "#{@stuff_in_intestine} - решайте сами вести в уборную или нет."
  end

  def age
    pet_age
  end

  private

  def hungry?
    @stuff_in_belly <= 3
  end

  def time_to_pass
    if @stuff_in_belly.positive?
      @stuff_in_belly -= 1
      @stuff_in_intestine += 1
    elsif @asleep
      @asleep = false
      @stuff_in_belly -= 1
    end
  end

  def want_to_sleep?
    if @asleep == false && @energy <= 2
    end
  end

  def death
    if @stuff_in_belly.zero? || @energy.zero?
      @lives -= 1
      @asleep = false
      @stuff_in_belly = 10
      @stuff_in_intestine = 0
      @energy = 10
      p "Осталось #{@lives} жизней."
    elsif @stuff_in_belly == 2 || @energy == 2
      @lives -= 1
      @asleep = false
      @stuff_in_belly = 10
      @stuff_in_intestine = 0
      @energy = 10
      p 'Смерть идет по пятам. Знать бы что нас ждет впереди...'
    elsif @stuff_in_belly > 10
      @lives -= 1
      @asleep = false
      @stuff_in_belly = 10
      @stuff_in_intestine = 0
      @energy = 10
      p "#{@name} уже не с нами. Готовьте пирожки."
    end
  end

  def pet_age
    age = Time.now - @birth_time
    p age
  end
end
