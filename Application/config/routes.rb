Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'applications', to: 'app#create'

  post 'applications/:app_token/chats', to: 'chats#create'

  post 'applications/:app_token/chats/:chat_id/messages', to: 'messages#create'
  get  'applications/:app_token/chats/:chat_id/messages/search', to: 'messages#search'

end
