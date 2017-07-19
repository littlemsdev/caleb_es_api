module V1
  class ApiController < ApplicationController

    class << self
      Swagger::Docs::Generator::set_real_methods

      def inherited(subclass)
        super
        subclass.class_eval do
          setup_basic_api_documentation
        end
      end

      def setup_authorization_header(api)
        api.param :header, 'Authorization', :string, :required, 'Token token={API Token}'
      end

      private

        def setup_basic_api_documentation
          [:index, :show, :create, :update, :destroy].each do |api_action|
            swagger_api api_action do
              param :header, 'Authorization', :string, :required, 'Token token={API Token}'
            end
          end
        end

    end

    # Generic API stuff here
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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

  end
end
