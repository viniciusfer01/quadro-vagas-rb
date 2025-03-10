module AuthenticationHelper
  def login_as(user)
    cookie_jar = ActionDispatch::Request.new(Rails.application.env_config.deep_dup).cookie_jar
    user.sessions.create!.tap do |session|
      cookie_jar.signed.permanent[:session_id] = { value: session.id, httponly: true, samesite: :lax }
      cookies[:session_id] = cookie_jar[:session_id]
    end
  end
end
