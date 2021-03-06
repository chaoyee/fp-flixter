Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"
  get "team" => "static_pages#team"
  get "careers" => "static_pages#careers"
  get "privacy" => "static_pages#privacy"
  resources :courses, only: [:index, :show] do
    get "(page/:page)", action: :index, on: :collection, as: ""
    resources :enrollments, only: [:create]
  end
  resources :lessons, only: :show
  resource :dashboard, only: :show do
    get "enrolled/:enrolled_page", action: :show, on: :member, as: "enrolled_page"
    get "taught/:taught_page", action: :show, on: :member, as: "taught_page"
    get "enrolled/:enrolled_page/taught/:taught_page", action: :show, on: :member, as: "both_page"
  end
  namespace :instructor do
    resources :courses, only: [:new, :create, :show] do
      resources :sections, only: [:create, :update]
    end
    resources :sections, only: [] do
      resources :lessons, only: [:create, :update]
    end
  end
  get "instructor/courses/:course_id/sections" => redirect("instructor/courses/%{course_id}")
  get "instructor/sections/:section_id/lessons" => redirect {|params|
    course = Section.find(params[:section_id]).course
    "instructor/courses/#{course.id}"
  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
