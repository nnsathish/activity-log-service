Rails.application.routes.draw do
  get 'health_check', to: 'application#health_check'
  scope :api, constraints: { format: 'json' } do
    resources :activity_logs, only: %i(index) do
      get :state, on: :collection
      post :upload, on: :collection
    end
  end
end
