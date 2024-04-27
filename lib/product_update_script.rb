require_relative 'services/ftp_client'
require_relative 'services/api_client'

require 'dotenv/load'
require 'fileutils'
require 'nokogiri'
require 'json'

def run_script
  download_products_xml
  products_json_data = convert_xml_to_json(File.read('lib/products.xml'))
  update_response = update_products(products_json_data)
  File.delete('lib/products.xml')

  puts update_response
rescue StandardError => e
  puts "Error: #{e.message}"
end

def download_products_xml
  ftp_client = Services::FtpClient.new(ENV.fetch('FTP_SERVER'))
  ftp_client.login(ENV.fetch('FTP_USER'), ENV.fetch('FTP_PASS'))
  ftp_client.get_text_file('products.xml', 'lib/products.xml')
  ftp_client.close
end

def convert_xml_to_json(xml_file_path)
  doc = Nokogiri::XML(xml_file_path)
  products_json_data = doc.xpath('//product').map do |product|
    {
      'SKU' => product['SKU'],
      'Item Name' => product['Item_Name'],
      'Brand' => product.at_xpath('./Brand')&.text,
      'Color' => product.at_xpath('./Color')&.text,
      'MSRP' => product.at_xpath('./MSRP')&.text,
      'Bottle Size' => product.at_xpath('./Bottle_Size')&.text,
      'Alcohol Volume' => product.at_xpath('./Alcohol_Volume')&.text,
      'Description' => product.at_xpath('./Description')&.text
    }.compact
  end.to_json
end

def update_products(products_json_data)
  api_client = Services::ApiClient.new(URI.parse(ENV.fetch('API_URL')))
  api_client.update_products(products_json_data)
end

run_script
