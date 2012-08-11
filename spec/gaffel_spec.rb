require 'gaffel'

describe "GoogleAnalyticsApi" do
  before do
    @google_account = {# --- registration:
                       :google_api_key => '***************************************',
                       :ga_profile_id  => 'ga:12345678',
                       :ga_property_id => 'xx-00000-00',
                       # --- login:
                       :login          => 'anonymous@anon.org',
                       :password       => '********',
                       :source         => 'gaffel'}
    @data_spec      = {:metric     => '',
                       :dimensions => [],
                       :start_date => 20120811,
                       :end_date   => 20120811}
    @ga_api         = Gaffel.new(@google_account, @data_spec)
  end

  it "should initialize request headers with authorization, version, and content type" do
    @ga_api.instance_variable_set(:@debug, true)
    EXPECTED_AUTH = /^GoogleLogin Auth=/
    EXPECTED_TYPE = "application/x-www-form-urlencoded"
    @ga_api.instance_variable_get("@headers_for_get_request").should_not be_nil
    @ga_api.instance_variable_get("@headers_for_get_request")["GData-Version"].should == "2"
    @ga_api.instance_variable_get("@headers_for_get_request")["Content-Type"].should == EXPECTED_TYPE
  end

  describe "make_url" do
    it "should generate a get request URL for obtaining a number of results, beginning from start index" do
      url = @ga_api.send :make_url, 1234
      url.should_not be_nil
      url = url.to_s
      url.should match /https:\/\//
      url.should match /end-date=/
      url.should match /start-date=/
      url.should match /max-results=/
      url.should match /start-index=/
    end
  end

end
