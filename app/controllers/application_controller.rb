class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # allows use of the pundit methods
  include Pundit::Authorization

  # checking the authorize method has been called, and then whether the user is meant to do anything on this page
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # scoping to ensure users are only seeing the records that they are supposed to.
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def should_verify_authorized?
    !skip_pundit? && action_name != "index"
  end

  def should_verify_policy_scoped?
    !skip_pundit? && action_name == "index"
  end

end
