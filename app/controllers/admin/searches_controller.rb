class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!
  # 検索機能のコントローラー(管理者)
  
  def search
    # viewのform_tagにて選択したmodelの値を@modelに代入。
    @model = params[:model]
    # 検索ワードを@contentに代入。
    @content = params[:content]
    # 選択した検索方法の値を@methodに代入。
    @method = params[:method]
    # @methodの値を日本語に変換する
    return_japanese
    # 選択したモデルがmemberだったら
    if @model == 'member'
      # search_forを@recordsに代入。
      @records = Member.search_for(@content,@method).page(params[:page]).per(8)
      # modelでなかったら
    else
      # search_forを@recordsに代入。
      @records = Manga.search_for(@content,@method).page(params[:page]).per(8)
    end
  end
  
  private
  # 日本語変換の為のアクション
  def return_japanese
  case @method
  when 'perfect' then
    @search = '完全一致'
  when 'forward' then
    @search = '前方一致'
  when 'backward' then
    @search = '後方一致'
  when 'partial' then
    @search = '部分一致'
  end
  end
end