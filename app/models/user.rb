class User < ActiveRecord::Base

  has_many :user_groups

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # user_idを必須、一意とする
  # 参照 : http://qiita.com/itboze/items/385d3cd539fc7578b52a
  validates_uniqueness_of :unique_name
  validates_presence_of :unique_name

  # paperclip用
  has_attached_file :avatar, styles: { medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :avatar, content_type: ["image/jpg","image/jpeg","image/png"]

end
