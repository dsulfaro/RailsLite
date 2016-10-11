require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req, @res = req, res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    unless already_built_response?
      @res.header["location"] = url
      @res.status = 302
      @already_built_response = true
    else
      raise "Double redirect error"
    end
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    byebug
    unless already_built_response?
      @res['Content-Type'] = content_type
      @res.write(content)
      @already_built_response = true
    else
      # double render error -- return? raise?
      raise "Double render error"
    end
    session.store_session(@req)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    unless already_built_response?
      template_path = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
      contents = File.read(template_path)
      template = ERB.new(contents).result(binding)
      render_content(template, "text/html")
      @already_built_response = true
    else
      raise "Double render error"
    end
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@res)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
