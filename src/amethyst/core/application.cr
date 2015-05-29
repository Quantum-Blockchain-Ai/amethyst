class Application
  property :port
  property :name
  getter   :routes

  def initialize(name= __FILE__, @port=8080)
    @name          = File.basename(name).gsub(/.\w+\Z/, "")
    @run_string    = "[Amethyst #{Time.now}] serving application \"#{@name}\" at http://127.0.0.1:#{port}" #TODO move to Logger class
    @midware_stack = MiddlewareStack.new
    @router        = Router.new
    @http_handler  = BaseHandler.new(@middleware_stack, @router)
  end

  def routes
    @router
  end

  def use(middleware : BaseMiddleware)
    @midware_stack.add middleware
  end

  def serve()
    puts @run_string
    server = HTTP::Server.new @port, @http_handler
    server.listen
  end
end

#TODO: Implement enviroments(production, development)
#TODO: Implement configuring app.configure(&block)
#TODO: Implement tracer module