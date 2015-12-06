require 'faraday'
require 'faraday_middleware'
require 'multi_xml'
require 'nokogiri'

class MastercardPlaces
  def initialize(base_url="http://dmartin.org:8006/merchantpoi/v1/merchantpoisvc.svc/")
    @conn = Faraday.new(url: base_url) do |conn|
      conn.response :xml,  :content_type => /\bxml$/
      conn.adapter Faraday.default_adapter
    end
  end

  def get_by_city_and_code(city, code, mcc=5411)
    begin
      results = []
      resp = @conn.get('merchantpoi', {'City' => city, 'PostalCode' => code, 'MCCCode' => mcc.to_s})

      resp.body['MerchantPOIList']['MerchantPOIArray']['MerchantPOI'].each do |merchant|
        merch_hash = {
          'open'    => merchant['InBusinessFlag'] == 'Y',
          'lat'     => merchant['Latitude'].to_f,
          'long'    => merchant['Longitude'].to_f,
          'name'    => merchant['MerchantName'],
          'address' => merchant['MerchantStreetAddress']
        }
        results << merch_hash
      end

      results
    rescue
      nil
    end
  end
end
