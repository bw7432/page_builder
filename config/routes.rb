PageBuilder::Engine.routes.draw do
	root to: redirect { |_params, request| "#{request.script_name}/admin/pages" }

	namespace :api do
		get "pages/:page_slug", to: "pages#show", as: :page
		post "pages/import", to: "pages#import_page", as: :import_page
	end

	scope :admin, as: :admin do
		root to: "pages#index"
		resources :pages
		resources :sections
		resources :rows
	end

	get "/:page_slug", to: "public_pages#show", as: :page_show
end
