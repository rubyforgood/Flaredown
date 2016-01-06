class ApplicationController < ActionController::API
  include ActionController::Serialization


  def root
    render text: 'flaredown'
  end

end
