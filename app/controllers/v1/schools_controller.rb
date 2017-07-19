module V1
  class SchoolsController < ApiController

    before_action :set_obj, only: [:show, :update, :destroy]

    swagger_controller :schools, 'Schools'

    swagger_api :index do
      summary 'Returns all schools'
      notes 'Expected JSON response data types:
      **Field**           | **Type**
      :---------:         |:--------:
      id                  | integer
      name                | string
      description         | text
      '
    end

    swagger_api :show do
      summary "Returns all of active schools"
      notes "ID, Name and Description"
      param :path, :id, :integer, :required, "School ID"
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
