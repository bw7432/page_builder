Rails.application.routes.draw do
  mount PageBuilder::Engine => "/page_builder"
end
