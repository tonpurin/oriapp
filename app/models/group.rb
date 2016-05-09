class Group < ActiveRecord::Base

  has_many :user_groups
  has_many :user_items

  # 新規グループのレコードを作成する際にデフォルト値を設定
  after_initialize :set_default, if: :new_record?

  # paperclip用
  has_attached_file :avatar, styles: { medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :avatar, content_type: ["image/jpg","image/jpeg","image/png"]

  private
  def set_default
    # avatarがnilだった場合
    if self.avatar.blank? then
      self.avatar = File.new("app/assets/images/no-image.png", "r")
    end
  end

end
