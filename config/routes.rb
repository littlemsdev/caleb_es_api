Rails.application.routes.draw do

  scope :format => true, :constraints => { :format => 'json' } do
    post   "/login"       => "sessions#create"
    delete "/logout"      => "sessions#destroy"

    namespace :v1 do
      get 'api-docs' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')

      resources :schools
    end

  end

end
