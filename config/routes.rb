Rails.application.routes.draw do
  # 会員用ログイン機能
  # URL /members/sign_in...
  devise_for :members, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  # 会員側のルーティング設定
  root to: 'public/homes#top'
  # about画面のルーティング
  get '/about', to: 'public/homes#about'
  scope module: 'public' do
    # お問い合わせのルーティング
    resources :contacts, only: %i[new create] do
      collection do
        post :confirm, :back
      end
    end
    get 'done', to: 'contacts#done', as: 'done'
    resources :mangas do
      # マンガの紹介＆感想文へのコメント
      resources :manga_comments, only: %i[create destroy]
      # マンガの紹介＆感想文へのいいね
      resource :favorites, only: %i[create destroy]
    end
    # マイページなど会員関連
    resources :members, only: %i[show edit update index] do
      # ユーザ別の投稿一覧
      member do
        get :detail
      end
      # フォロー機能
      resource :relationships, only: %i[create destroy]
      member do
        # フォロー・フォロワー一覧
        get :following, :followers
        # 退会画面表示機能
        get :unsubscribe
        # 退会機能
        patch :withdrawal
      end
    end
    # フォロワー同士のDM
    resources :messages, only: %i[create show]
    # get 'message/:id', to: 'messages#show', as: 'message'
    # 検索のルーティング
    get '/search', to: 'searches#search'
  end

  # 管理者用ログイン機能
  # URL /admin/sign_in...
  devise_for :admin, skip: %i[registrations passwords], controllers: {
    sessions: 'admin/sessions'
  }
  # 管理者側のルーティング設定
  namespace :admin do
    resources 'members', except: %i[destroy new create] do
      # ユーザ別の投稿一覧
      member do
        get :detail
      end
    end
    resources 'mangas', only: %i[index show destroy]
    # 検索のルーティング
    get '/search', to: 'searches#search'
  end
end
