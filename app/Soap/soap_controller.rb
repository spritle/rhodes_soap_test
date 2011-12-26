require 'rho/rhocontroller'
require 'net/http'
require 'rexml/document'

# Dont forget to add rhoxml and net-http to the build.yml as extension

class SoapController < Rho::RhoController
  def input
      
  end
  
  def to_fahrenheit
      @result = call_soap_for_c2f(@params['convert']['celsius'])
      render :action => :output
  end
  
  def output
  end
  
private 
  def call_soap_for_c2f(celsius)
      http = Net::HTTP.new('www.w3schools.com', 80)
      path = '/webservices/tempconvert.asmx'

# Create the SOAP Envelope
data = <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope
xmlns:xsd="http://www.w3.org/2001/XMLSchema"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
<SOAP-ENV:Body>
  <CelsiusToFahrenheit xmlns="http://tempuri.org/">
        <Celsius>#{celsius}</Celsius>
  </CelsiusToFahrenheit>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
EOF
      
      # # Set Headers
      headers = {
        'Content-Type' => 'text/xml',
        'Host' => 'spritle.com'
      }
      
      resp, data = http.post(path, data, headers)
      
      xmldoc = REXML::Document.new(data)
      #TODO: Needs a better error handling
      @result = nil
      xmldoc.elements.each("soap:Envelope/soap:Body/CelsiusToFahrenheitResponse/CelsiusToFahrenheitResult") { |e|
          @result = e.text
      }
      @result ? @result : "Error occurred. Check rholog."
  end
  
end