# 緯度経度からじゃらんの宿泊施設を取得
# 参照 : http://www.jalan.net/jw/jwp0200/jww0203.do
# http://www.jalan.net/jw/jwp0100/jww0101.do

require 'net/http'
require 'uri'
require 'rexml/document'

class JaranAPI

  def get_test_data
    test_data = []
    hotel1 = {"name" => "ラビスタ函館ベイ","detail_url" => "http://www.jalan.net/JwsRedirect.do?key=vir1549dce10c5&amp;rd_key=MzEzNDY0LCwsLDEsMSwsLCwsLCwwMSwwMA==","picture_url" => "http://www.jalan.net/jalan/images/pictSS/Y4/Y313464/Y313464633.jpg"}
    hotel2 = {"name" => "函館グランドホテル","detail_url" => "http://www.jalan.net/JwsRedirect.do?key=vir1549dce10c5&rd_key=MzkzODQ0LCwsLDEsMSwsLCwsLCwwMSwwMA==","picture_url" => "http://www.jalan.net/jalan/images/pictSS/Y4/Y393844/Y393844605.jpg"}
    hotel3 = {"name" => "函館国際ホテル","detail_url" => "http://www.jalan.net/JwsRedirect.do?key=vir1549dce10c5&rd_key=MzIyNDc2LCwsLDEsMSwsLCwsLCwwMSwwMA==","picture_url" => "http://www.jalan.net/jalan/images/pictSS/Y6/Y322476/Y322476As8.jpg"}
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
    # xml取得
    xml_doc = get_xml_body(m_jx.round, m_jy.round, radius, count)
    # 情報の抽出
    hotel_info = get_hotel_info(xml_doc)
    return hotel_info
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
    return doc
  end

  def get_hotel_info(xml_document)
    """
    xmlからホテルの情報を抽出
    """
    hotel_info_array = [];
    xml_document.elements.each('Results/Hotel/') {|i|

      hotel_info = {}
      hotel_info["name"] = i.elements["HotelName"].text
      hotel_info["address"] = i.elements["HotelAddress"].text
      hotel_info["detail_url"] = i.elements["HotelDetailURL"].text
      hotel_info["picture_url"] = i.elements["PictureURL"].text
      hotel_info["m_jx"] = i.elements["X"].text
      hotel_info["m_jy"] = i.elements["Y"].text

      hotel_info_array << hotel_info
    }
    return hotel_info_array
  end

  def change_location_global_to_japan(wx, wy)
    """
    世界測地系→日本測地系の変換処理
    """
    jx = wx * 1.000083049 + wy * 0.000046047 - 0.010041046;
    jy = wy * 1.000106961 - wx * 0.000017467 - 0.004602017;
    return [jx, jy];
  end

  def change_degree_to_millisec(jx, jy)
    """
    緯度経度をdegree形式からミリ秒形式に変換
    """
    milli_jx = jx * 3600 * 1000
    milli_jy = jy * 3600 * 1000
    return [milli_jx, milli_jy]
  end
end

