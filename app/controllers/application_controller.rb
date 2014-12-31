class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods
  #http_basic_authenticate_with :name => "gnp", :password => "secret"

end
