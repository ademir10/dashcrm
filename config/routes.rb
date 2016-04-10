Rails.application.routes.draw do
   
  resources :clients
  resources :documents
  resources :solutions
  resources :advices
  resources :questions do
  resources :answers 
  end
  
  resources :airsearches do
    member do
      get 'manage_air'
      post 'update_status_air'
    end
  end
  resources :categories
 resources :expire_dates
 resources :users
  
  
  #para exibir a imagem que foi feito o upload
  get 'show_file' => 'documents#show_file'
    
  root 'pages#index'
  get 'sessions/new'
  
  #rotas para o login
  get 'expired', to: 'sessions#expired_date'
  get 'pages/index'
  get 'login', to: 'sessions#new'
  delete 'logout', to: 'sessions#destroy'
  post 'login', to: 'sessions#create'
  #---------------------------------------------
  
  #rotas para contato
  get 'contact', to: 'messages#new', as: 'contact'
  post 'contact', to: 'messages#create'
  #---------------------------------------------
  #somente para chamar a edição do usuario quando for um membro logado
  get 'editar_user', to: 'users#chama_edicao'
  #---------------------------------------------
  
  #relatórios
  get 'business_report', to: 'pages#business_report'
  
    
  #para carregar a view informando que não pode excluir cadastro com relacionamento em outra table
  get 'message_error_relation_tables', to: 'messages#message_error_relation_tables'
  end


