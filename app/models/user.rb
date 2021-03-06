# -*- coding: utf-8 -*-

# = ユーザモデル
# Author:: Dolphin
# Date:: 2013.01.26
#
# == フィールド
# * *id*             : 通し番号
# * *login_id*       : ログイン時に用いるID
# * *password*       : パスワードのハッシュ値
# * *mail_addr*      : メールアドレス
# * *nick_name*      : ニックネーム(表示用)
# * *real_name*      : 実名
# * *twitter*        : Twitter ID
# * *pixiv*          : Pixiv ID
# * *phone_number*   : 電話番号
# * *account_type*   : アカウントの種別(TYPE_***)
# * *account_status* : アカウントの状態(STATUS_***)
# * *last_login*     : 最終ログインに知事
# * *created_at*     : 作成日時
# * *updated_at*     : 更新日時
#
class User < ActiveRecord::Base
  include CryptHelper
  validates :login_id, :presence => true, :uniqueness => true
  validates :password, :presence => true

  attr_accessible :id, :login_id, :password, :mail_addr, :nick_name, :real_name, :twitter, :pixiv, :phone_number, :account_type, :account_status, :last_login, :created_at, :updated_at

  # アカウント種別 一般ユーザ
  TYPE_USER = 0
  
  # アカウント種別 システム管理者
  TYPE_ADMIN = 100

  # 状態コード 無効
  STATUS_DISABLED = 0

  # 状態コード 有効
  STATUS_ENABLED = 1

  # アカウント種別のハッシュ配列を返す。
  #
  # === 返り値
  # [Hash] { 名称 => 値 } の形で、アカウント種別一覧を返す。
  #
  def self.account_types
    return {
      '一般ユーザ'       => TYPE_USER,
      'システム管理者'   => TYPE_ADMIN
    }

  end

  # アカウント状態のハッシュ配列を返す。
  #
  # === 返り値
  # [Hash] { 名称 => 値 } の形で、アカウント状態一覧を返す。
  #
  def self.account_statuses
    return {
      '有効'         => STATUS_ENABLED,
      '無効'         => STATUS_DISABLED
    }

  end

  # ユーザがシステム管理者かどうかを判定する。
  #
  # === 返り値
  # [true] システム管理者
  # [false] システム管理者ではない
  #
  public
  def is_admin?
    return true if self.account_type == User::TYPE_ADMIN
    return false
  end
  
  # ログインIDからユーザを検索する。
  #
  # === 引数
  # [loginid] 検索したいユーザのログインID
  #
  # === 返り値
  # [User] ユーザが見つかった場合、ユーザオブジェクトを返す。
  # [nil]  ユーザが見つからなかった場合
  #
  def self.find_by_login_id( loginid )
    user = User.find(
      :all,
      :conditions => {
      :login_id => loginid
    }
    )

    return nil if user.count <= 0
    return user[0]

  end

  # 全てのアカウントを取得する。
  #
  # === 返り値
  # [array(User)] ユーザオブジェクトの配列
  #
  def self.find_all
    users = User.find( :all )
    return users

  end

  # 有効な全てのアカウントを取得する。
  #
  # === 返り値
  # [array(User)] ユーザオブジェクトの配列
  #
  def self.find_all_enabled
    users = User.find( :all, :conditions => { :account_status => STATUS_ENABLED } )
    return users

  end

  # ログインID と パスワード から、認証を行う。
  #
  # === 引数
  # [login_id] ログインID
  # [password] パスワード
  #
  # === 返り値
  # [true] 認証成功
  # [false] 認証失敗
  #
  def self.auth( login_id, password )
    user = User.find( 
      :all, 
      :conditions => {
        :login_id => login_id, 
        :password => User.make_password_hash( password ), 
        :account_status => [ STATUS_ENABLED ] 
      }
    )

    return false if user.count <= 0
    return true

  end

  # パスワードのハッシュを生成する。
  #
  # === 引数
  # [password] パスワード文字列
  #
  # === 返り値
  # [string] パスワードハッシュ値
  #
  def self.make_password_hash( password )
    password = "" if password == nil
    return CryptHelper::make_sha1( password ).to_s

  end

  # ユーザアカウントを作成する。
  # 引数で指定された情報から、新規にユーザをデータベースへ追加する。
  #
  # === 引数
  # [login_id] 希望のログインID
  # [password] パスワード
  #
  # === 返り値
  # [User] 追加に成功した場合、作成したユーザオブジェクトを返す。
  # [false] 追加に失敗
  #
  def self.create_user( login_id, password, type = TYPE_USER, mail_addr = '', nick_name = '', real_name = '', twitter = '', pixiv = '' )
    new_user = self.create(
      :login_id       => login_id,
      :password       => make_password_hash( password ),
      :account_type   => type,
      :mail_addr      => mail_addr,
      :nick_name      => nick_name,
      :real_name      => real_name,
      :twitter        => twitter,
      :pixiv          => pixiv,
      :account_status => STATUS_ENABLED
    )

    return false if new_user.new_record?
    return new_user

  end

  # 指定されたログインIDが存在しているかチェックする。
  #
  # === 引数
  # [login_id] ログインID
  #
  # === 返り値
  # [true] 指定されたログインIDが存在
  # [false] 指定されたログインIDが存在しない
  #  
  def self.is_exists_login_id( login_id )
    user = User.find( 
      :all, 
      :conditions => {
        :login_id => login_id 
      }
    )

    return true if user.count > 0
    return false

  end

  # アカウント種別名を取得する。
  #
  # === 返り値
  # [string] 種別名
  #
  def type_name
    User.account_types.each do |name, val|
      return name if val == self.account_type
    end
    return '不明'

  end

  # 最終ログイン日時を更新する。
  def login
    self.last_login = DateTime.now
    self.save

  end

  # 名前を取得する。
  # ニックネームが設定されている場合はニックネームを返す。
  # ニックネームが設定されていなければ、ログインIDを返す。
  #
  # === 返り値
  # [string] 名前
  #
  def name
    return self.nick_name if self.nick_name != ''
    return self.login_id

  end

  # 有効な管理者を探す。
  def self.find_by_enabled_admin
    user = User.find(
      :all,
      :conditions => {
        :account_type => TYPE_ADMIN,
        :account_status => STATUS_ENABLED
      }
    )

    return user

  end

end
