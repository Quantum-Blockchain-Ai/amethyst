require "../src/all"

class TimeLogger < Middleware::Base

  # This one will be called when app gets request. It accepts Http::Request
  def call(request)
    logger   = Base::App.logger
    t_req    = Time.now
    response = @app.call(request)
    t_res    = Time.now
    elapsed  = (t_res - t_req).to_f*1000
    string   = "%.4f ms" % elapsed
    response.body += "<hr>"+string
    response
  end
end

class TestController < Controller
  actions :index, :user, :hello

  def index
    html "Hello world!<img src='/assets/amethyst.jpg'>"
  end

  view "hello", "#{__DIR__}/views", name
  def hello
    name = "Andrew"
    respond_to do |format|
      format.html { render "hello", name }
    end
  end

  def user
    html "Hello from user #{request.path_parameters["id"]}"
  end
end

class MyApp < Base::App

  settings.configure do |conf|
    conf.environment = "development"
  end

  routes.draw do
    get  "/user/:id", "test#user"
    post "/post/", "test#index"
    all  "/", "test#hello"
    register TestController
  end

  use TimeLogger
end

MyApp.new.serve