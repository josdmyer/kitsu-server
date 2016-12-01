module DoorkeeperHelpers
  extend ActiveSupport::Concern

  included do
    before_action :validate_token!
  end

  def current_user
    doorkeeper_token
  end

  # Return boolean representing whether there is a user signed in
  def signed_in?
    current_user.present?
  end

  # Validate token
  def validate_token!
    # If we have a token, but it's not valid, explode
    if doorkeeper_token && !doorkeeper_token.accessible?
      jsonapi_render_errors json: [{ title: 'Invalid token' }], status: 403
    end
  end

  # Provide context of current user to JR
  def context
    { current_user: current_user }
  end
end
