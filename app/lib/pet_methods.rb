module Pet_Methods
  def self.change_params(request, name)

    Rack::Response.new do |r|
      r.set_cookie(name, request.cookies["#{name}"].to_i + 1) if request.cookies["#{name}"].to_i < 10

      command = ($COMMANDS - [name]).sample

      r.set_cookie(command, request.cookies["#{command}"].to_i - 2)
   
      r.redirect('/play')
    end
  end

  def self.rave_params(request, name)

    Rack::Response.new do |r|
      r.set_cookie(name, request.cookies["#{name}"].to_i - 3)

      r.redirect('/play')
    end
  end

  def self.sleep_params(request, name)

    Rack::Response.new do |r|
      r.set_cookie(name, request.cookies["#{name}"].to_i + 2)

      r.redirect('/play')
    end
  end

  def self.bath_params(request, name)

    Rack::Response.new do |r|
      r.set_cookie(name, request.cookies["#{name}"].to_i + 3)

      r.redirect('/play')
    end
  end

  def self.pet_params(request, name)

    Rack::Response.new do |r|
      r.set_cookie(name, request.cookies["#{name}"].to_i + 4)

      r.redirect('/play')
    end
  end

end
