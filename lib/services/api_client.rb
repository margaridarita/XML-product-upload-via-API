require 'net/http'

module Services
  class ApiClient
    def initialize(base_url)
      @base_url = base_url
      @http = Net::HTTP.new(base_url.host, base_url.port)
      @http.use_ssl = (base_url.scheme == 'https')
    end

    # GET /api/v1/products/<product_id>
    def get_product(product_id)
      send_request(Net::HTTP::Get, "/api/v1/products/#{product_id}")
    end

    # POST /api/v1/products
    def post_product(body)
      send_request(Net::HTTP::Post, "/api/v1/products", body)
    end

    # PUT /api/v1/products/<product_id>
    def update_product(product_id, body)
      send_request(Net::HTTP::Put, "/api/v1/products/#{product_id}", body)
    end

    # PUT /api/v1/products
    def update_products(body)
      send_request(Net::HTTP::Put, "/api/v1/products", body)
    end

    # DELETE /api/v1/products/<product_id>
    def delete_product(product_id)
      send_request(Net::HTTP::Delete, "/api/v1/products/#{product_id}")
    end

    private

    def send_request(request_class, endpoint, body = nil)
      uri = URI.join(@base_url, endpoint)
      request = request_class.new(uri)
      request['Authorization'] = "Bearer #{ENV.fetch('API_KEY')}"
      if body
        request['Content-Type'] = 'application/json'
        request.body = body
      end

      response = @http.request(request)
      handle_response(response)
    end

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        response.body ? JSON.parse(response.body) : true
      else
        response.body ? JSON.parse(response.body) : false
      end
    end
  end
end
