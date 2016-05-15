# 緯度経度からじゃらんの宿泊施設を取得
# 参照 : http://www.jalan.net/jw/jwp0200/jww0203.do
# http://www.jalan.net/jw/jwp0100/jww0101.do

require 'net/http'
require 'uri'
require 'rexml/document'

class JaranAPI

  def get_test_data
    test_data = []
    hotel1 = {"id" => 313464, "name" => "ラビスタ函館ベイ","address" => "北海道函館市豊川町１２－６","detail_url" => "http://www.jalan.net/JwsRedirect.do?key=vir1549dce10c5&amp;rd_key=MzEzNDY0LCwsLDEsMSwsLCwsLCwwMSwwMA==","picture_url" => "http://www.jalan.net/jalan/images/pictSS/Y4/Y313464/Y313464633.jpg", "catchcopy" => "じゃらんアワード2014泊まって良かった宿大賞301室以上で道内１位", "lng" => 140.7190667559249, "lat" => 41.767434752453894}
    hotel2 = {"id" => 393844, "name" => "函館グランドホテル","address" => "北海道函館市宝来町２２番地１５号", "detail_url" => "http://www.jalan.net/JwsRedirect.do?key=vir1549dce10c5&rd_key=MzkzODQ0LCwsLDEsMSwsLCwsLCwwMSwwMA==","picture_url" => "http://www.jalan.net/jalan/images/pictSS/Y4/Y393844/Y393844605.jpg", "catchcopy" => "小学生添寝無料★イクラ盛り放題！朝食が人気★ベイエリア徒歩7分" ,"lng" => 140.72018663462404, "lat" => 41.762016740418076}
    hotel3 = {"id" => 322476, "name" => "函館国際ホテル", "address" => "函館市大手町5-10","detail_url" => "http://www.jalan.net/JwsRedirect.do?key=vir1549dce10c5&rd_key=MzIyNDc2LCwsLDEsMSwsLCwsLCwwMSwwMA==","picture_url" => "http://www.jalan.net/jalan/images/pictSS/Y6/Y322476/Y322476As8.jpg", "catchcopy" => "◆港街に佇む老舗シティホテルで寛ぎのひとときを◆", "lng" => 140.72231971747556, "lat" => 41.769641795429926}
    test_data << hotel1
    test_data << hotel2
    test_data << hotel3
    return test_data
  end

  def search_hotel(lng, lat, radius, count)
    """
    対象のマーカーのジオコードから周辺の宿泊施設の情報を取得
    """
    # 緯度経度をAPI用の形式に
    wx = lng
    wy = lat
    jx, jy = change_location_global_to_japan(wx, wy)
    m_jx, m_jy = change_degree_to_millisec(jx, jy)

    # 利用制限注意
    # xml取得 (確認のurl)
    xml_doc, url = get_xml_body(m_jx.round, m_jy.round, radius, count)
    # 情報の抽出
    hotel_info = get_hotel_info(xml_doc)
    return [hotel_info, url]
  end

  private
  def get_xml_body(m_jx, m_jy, radius, count)
    """
    変換された緯度経度と半径から宿泊施設の情報を持つXMLを返す
    m_jx : 日本測地系かつミリ秒形式に変換された経度
    m_jy : 日本測地系かつミリ秒形式に変換された緯度
    """
    url = URI.parse("http://jws.jalan.net/APIAdvance/HotelSearch/V1/?order=4&xml_ptn=1&pict_size=0&key=vir1549dce10c5&x=#{m_jx}&y=#{m_jy}&range=#{radius}&count=#{count}")
    res = Net::HTTP.start(url.host, url.port){|http| http.get(url.path + "?" + url.query);}
    doc = REXML::Document.new(res.body)
    return [doc, url]
  end

  def get_hotel_info(xml_document)
    """
    xmlからホテルの情報を抽出
    """
    hotel_info_array = [];
    xml_document.elements.each('Results/Hotel/') {|i|

      hotel_info = {}
      hotel_info["id"] = i.elements["HotelID"].text
      hotel_info["name"] = i.elements["HotelName"].text
      hotel_info["address"] = i.elements["HotelAddress"].text
      hotel_info["detail_url"] = i.elements["HotelDetailURL"].text
      hotel_info["picture_url"] = i.elements["PictureURL"].text
      hotel_info["catchcopy"] = i.elements["HotelCatchCopy"].text

      # 世界測に変換する必要あり
      milli_jx = i.elements["X"].text.to_f
      milli_jy = i.elements["Y"].text.to_f
      jx, jy = change_millisec_to_degree(milli_jx, milli_jy)
      wx, wy = change_location_japan_to_global(jx, jy)
      hotel_info["lng"] = wx
      hotel_info["lat"] = wy

      hotel_info_array << hotel_info
    }
    return hotel_info_array
  end

  def change_location_global_to_japan(wx, wy)
    """
    世界測地系→日本測地系の変換処理
    """
    jx = wx * 1.000083049 + wy * 0.000046047 - 0.010041046
    jy = wy * 1.000106961 - wx * 0.000017467 - 0.004602017
    return [jx, jy];
  end

  def change_location_japan_to_global(jx, jy)
    """
    日本測地系→世界測地系の変換処理
    """
    wy = jy - jy * 0.00010695 + jx * 0.000017464 + 0.0046017
    wx = jx - jy * 0.000046038 - jx * 0.000083043 + 0.010040
    return [wx, wy];
  end

  def change_degree_to_millisec(jx, jy)
    """
    緯度経度をdegree形式からミリ秒形式に変換
    """
    milli_jx = jx * 3600 * 1000
    milli_jy = jy * 3600 * 1000
    return [milli_jx, milli_jy]
  end

   def change_millisec_to_degree(milli_jx, milli_jy)
    """
    緯度経度をミリ秒形式からdegree形式に変換
    """
    jx = milli_jx / (3600 * 1000)
    jy = milli_jy / (3600 * 1000)
    return [jx, jy]
  end

end

