require 'json'

class Flash

  def initialize(req)
    if req.cookies != {}
      @cookies = JSON.parse(req.cookies["_rails_lite_app_flash"])
    else
      @cookies = {}
    end
  end

  def []=(key, val)
    @cookies[key] = val
  end

  def [](key)
    @cookies[key.to_s]
  end

  def store_flash(res)
    json = @cookies.to_json
    cookies_attributes = { path: "/", value: json }
    res.set_cookie("_rails_lite_app_flash", cookies_attributes)
  end

  def now
    ## TODO ##
  end

end
