class User < ActiveRecord::Base

  has_many :user_groups

  # 新規ユーザのレコードを作成する際にデフォルト値を設定
  after_initialize :set_default, if: :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:unique_name]

  # email, unique_nameを必須、一意とする
  # 参照 : http://qiita.com/itboze/items/385d3cd539fc7578b52a
  validates_uniqueness_of [:email, :unique_name]
  validates_presence_of [:email, :unique_name]

   # unique_nameを仕様してログインするようオーバーライド
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # 認証の条件式を変更する
      where(conditions).where(["unique_name = :value", {:value => unique_name}]).first
    else
      where(conditions).first
    end
  end

  # 登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end

  # paperclip用
  has_attached_file :avatar, styles: { medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :avatar, content_type: ["image/jpg","image/jpeg","image/png"]

  private
  def set_default
    self.avatar = File.new("app/assets/images/no-image.png", "r")
  end

end
