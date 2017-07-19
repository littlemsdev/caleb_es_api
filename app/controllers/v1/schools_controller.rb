module V1
  class SchoolsController < ApiController

    before_action :require_token_authentication
    before_action :set_obj, only: [:show, :update, :destroy]

    swagger_controller :schools, 'Schools'

    swagger_api :index do
      summary 'Returns all schools'
      notes 'Notes...'
    end

    def index
      @objs = School.all
      render json: @objs.to_json, status: :ok
    end

    def show
      render json: @obj
    end

    def create
      @obj = School.new(obj_params)

      if @obj.save
        render json: @obj, status: :created
      else
        obj_errors
      end
    end

    def update
      if @obj.update(obj_params)
        render json: @obj, status: :updated
      else
        obj_errors
      end
    end

    private

    def set_obj
      @obj = School.find(params[:id])
    end

    def obj_params
      params.permit(:code, :name, :description)
    end

  end
end
