class ApiController < ActionController::Base

  def require_token_authentication
    authenticate_token || render_unauthorized("Access denied")
  end

  def current_user
    @current_user ||= authenticate_token
  end

  protected

  def render_unauthorized(message)
    errors = { errors: [ { detail: message } ] }
    render json: errors, status: :unauthorized
  end

  def render_obj_errors(obj = nil)
    render json: {
      message: 'Validation failed', errors: (obj || @obj).errors.full_messages
    }, status: 422
  end

  def obj_not_found
    render json: {
      message: 'ID not found'
    }
  end

  def obj_errors
    render json: { message: 'Validation failed', errors: @obj.errors.full_messages }, status: 422
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      if user = User.with_unexpired_token(token, 2.days.ago)
        # Compare the tokens in a time-constant manner, to mitigate timing attacks.
        ActiveSupport::SecurityUtils.secure_compare(
                        ::Digest::SHA256.hexdigest(token),
                        ::Digest::SHA256.hexdigest(user.token))
        user
      end
    end
  end

end
