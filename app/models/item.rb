class Item < ActiveRecord::Base

  has_many :user_items

  def self.to_hash(model_data, key)
    """
    ActiveRecordのオブジェクトを指定のkeyでhashに変換
    :param string : key
    :param Item::ActiveRecord_Relation : model_data
    """
    hash_data = {}

    # オブジェクトの照合
    if model_data.kind_of?(Item::ActiveRecord_Relation) then
      # arrayの場合...
      model_data.each do |md|
        hash_data[md[key]] = md
      end
    else
      hash_data[model_data[key]] = model_data
    end
    return hash_data
  end

  def self.get_genre_img(genre)
    """
    Genreによって画像を返す
    """
    # gurume = [""]
  end

end