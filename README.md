## XML-product-upload-via-API
This exercise is a technical challenge with the goal of building a script that is capable of updating products via an API, with data from an XML file on an FTP server.

## Technologies Used
* Ruby 3.1.2
  
## Services Used
* Git
* Github

## 3rd-Party Libraries / Ruby Gems
* 'dotenv', '~> 3.1' ; used to load the API/user/pass credentials into the script without exposing them on the public repository.
* 'nokogiri', '~> 1.16', '>= 1.16.4' ; used to parse the XML using its support for XPath. I chose Nokorigi because I had used it in the past and knew it would do the job efficiently.
* 'json', '~> 2.7', '>= 2.7.2' ; used to serialize the parsed products data into JSON format with the to_json method.

## Documentation / Websites Visited
* For the FTP connection - https://ruby-doc.org/stdlib-2.4.0/libdoc/net/ftp/rdoc/Net/FTP.html
* For the API connection - https://ruby-doc.org/stdlib-2.7.0/libdoc/net/http/rdoc/Net/HTTP.html
* For parsing the file - https://github.com/sparklemotion/nokogiri ; https://ruby-doc.org/stdlib-2.6.3/libdoc/json/rdoc/JSON.html

## How the Script Works
First, to separate concerns, I created two service classes to handle the FTP and API connections:
* `Services::FtpClient` - responsible for connecting to the FTP server and downloading the XML file.
* `Services::ApiClient` - responsible for connecting to the different API endpoints and retrieving the responses. Since all endpoints were mentioned in the exercise, I decided to create a method for each. I noticed that it was possible to update products in bulk calling `PUT /api/v1/products/<product_id>`, however, for the update action I still decided to create a separate method that calls `PUT /api/v1/products` to be more clear.

Then the script runs the following steps:
1. Connects to the FTP server and downloads the `products.xml` file into the `lib` folder;
2. Converts the XML file data into JSON;
3. Updates the products by making a PUT request to the endpoint `/api/v1/products`;
4. Deletes the file after the request is complete;
5. Shows the API call response to the user.

## Getting Started
Before you begin, make sure to have Ruby installed.

1. Clone this repository

   ```bash
   git clone https://github.com/margaridarita/XML-product-upload-via-API

2. Install the gems

   ```bash
   bundle install

3. Run the script

   ```bash
   ruby lib/product_update_script.rb

## Local Tests
- [X] On `lib/product_update_script.rb`, inside the `run_script` method, add a return statement on the line next to the call to `download_products_xml`. Then run the script, and confirm that the `products.xml` file was downloaded into the `lib` directory.
- [X] On the same method, comment the line `download_products_xml`, and remove the return statement. Comment as well the line `File.delete('lib/products.xml')`. The goal is to use the downloaded file and influence its content to test the API endpoints.
- [X] Change some fields on the products file (except SKUs). Then run the script and confirm on the app that the products' fields were updated.
- [x] Test as well the other endpoints by calling their methods on the script. E.g. to test GET add: api_client.get_product("product's_sku").
- [x] Change some information of the products in the app. Then uncomment the commented lines and run the script. Confirm that the products were updated on the app according to the XML file.
- [x] Add an incorrect API_TOKEN to the `.env` file. Then run the script and confirm you receive an error message.

## Total Time Spent
The total time spent on this exercise, including investigating, executing, and testing was 4h.

If I had unlimited time, this is what I would do (1 is highest priority):
1. Better investigate which types of error responses can be returned by the FTP and API, and implement a more robust error-handling mechanism to provide meaningfull messages to the users;
2. Implement unit tests to validate a) the connection and file transfer on the FTP; b) the request handling of the API; c) the conversion of XML into JSON;
3. Implement integration tests to test the entire script functionality.
   
## Code Critique
What I would critique in my code is that I am mapping each product and extracting their properties one by one to create the JSON. This works well for the 4 products that are on the file for this challenge, but what if we had hundred of products like in a real-life case?
