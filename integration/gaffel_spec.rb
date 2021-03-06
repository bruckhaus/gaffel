require 'gaffel'

describe "GoogleAnalyticsApi" do

  before do
    @google_account = {# --- registration:
                       :google_api_key => '***************************************',
                       :ga_profile_id  => 'ga:12345678',
                       :ga_property_id => 'xx-00000-00',
                       # --- login:
                       :login          => 'anonymous@anon.com',
                       :password       => '********',
                       :source         => 'gaffel'}
    @data_spec      = {:metric     => '',
                       :dimensions => [],
                       :start_date => 20120811,
                       :end_date   => 20120811}
    @ga_api         = Gaffel.new(@google_account, @data_spec)
    @ga_api.instance_variable_set(:@debug, true)
    @ga_api = Gaffel.new(@google_account, @data_spec)
  end

  describe "http_get_request" do
    it "should generate a valid response" do
      url = @ga_api.send :make_url, 123
      @ga_api.send :get_auth_token
      response = (@ga_api.send :http_get_request, url)
      response.should_not be_nil
      response.code.to_i.should == 200
    end
  end

end
