PageBuilder::Engine.routes.draw do
	root to: "pages#index"

	resources :pages
	resources :sections
	resources :rows

	get "/:page_slug", to: "pages#show", as: :page_show
end
