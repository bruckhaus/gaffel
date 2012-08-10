#noinspection RubyStringKeysInHashInspection
class Gaffel
  # --- login:
  CLIENT_LOGIN_URL               = 'https://www.google.com/accounts/ClientLogin'
  ACCOUNT_TYPE                   = 'GOOGLE'
  SERVICE                        = 'analytics'
  CONTENT_TYPE                   = 'application/x-www-form-urlencoded'
  LOGIN_HEADERS                  = {'Content-Type' => CONTENT_TYPE}
  # --- get request:
  GA_CORE_REPORTING_API_URL_V2_3 = 'https://www.google.com/analytics/feeds/data'
  GA_CORE_REPORTING_API_URL_V2_4 = 'https://www.googleapis.com/analytics/v2.4/data'
  GA_CORE_REPORTING_API_URL_V3_0 = 'https://www.googleapis.com/analytics/v3/data/ga'
  GA_CORE_REPORTING_API_URL      = GA_CORE_REPORTING_API_URL_V3_0

  def initialize(account, data_spec)
    @debug                   = false
    @account                 = account
    @data_spec               = {:metric      => (data_spec[:metric] || 'ga:newVisits'),
                                :dimensions  => (data_spec[:dimensions] || []).join(','),
                                :filters     => (data_spec[:filters] || ''),
                                :start_date  => iso_date(data_spec[:start_date]),
                                :end_date    => iso_date(data_spec[:end_date]),
                                :max_results => (data_spec[:max_results] || 1000),
                                :sort        => (data_spec[:sort] || 'ga:date')}
    @data_spec[:filters]     += ";#{@data_spec[:metric]}>0"
    @login_query             = {:Email       => @account[:login],
                                :Passwd      => @account[:password],
                                :source      => @account[:source],
                                :accountType => ACCOUNT_TYPE,
                                :service     => SERVICE}.to_query
    @headers_for_get_request = {"GData-Version" => '2',
                                "Content-Type"  => CONTENT_TYPE}
    @rows_processed          = 0
  end

  def each
    get_auth_token
    start_index = 1
    while true
      url = make_url(start_index)
      debug("url", url)
      response = http_get_request(url)
      debug("response", response)
      ga_data = JSON.parse(response.read_body)
      debug("ga_data", ga_data)
      break if done_reading ga_data
      headers = ga_data['columnHeaders']
      ga_data['rows'].each { |values| yield make_hash(headers, values) }
      start_index += @data_spec[:max_results]
    end
  end

# ---
  protected

  def make_hash(headers, values)
    hash = {}
    headers.each_with_index do |header, i|
      hash = hash.merge({header['name'].to_sym => values[i]})
    end
    hash
  end

  def done_reading(ga_data)
    ga_data["query"]["start-index"] > ga_data["totalResults"]
  end

  def http_get_request(url)
    http         = Net::HTTP.new url.host, 443
    http.use_ssl = url.scheme == 'https'
    http.request_get(url.request_uri, @headers_for_get_request)
  end

  def get_auth_token
    url                      = URI CLIENT_LOGIN_URL
    http                     = Net::HTTP.new url.host, 443
    http.use_ssl             = url.scheme == 'https'
    response                 = http.request_post(url.request_uri, @login_query, LOGIN_HEADERS)
    auth                     = response.read_body.scan(/Auth=.*/).first
    @headers_for_get_request = @headers_for_get_request.merge("Authorization" => "GoogleLogin #{auth}")
  end

  def make_url(start_index)
    #see: http://ga-dev-tools.appspot.com/explorer/
    query = {"start-index" => start_index.to_s,
             "metrics"     => @data_spec[:metric],
             "dimensions"  => @data_spec[:dimensions],
             "filters"     => @data_spec[:filters],
             "max-results" => @data_spec[:max_results],
             "start-date"  => @data_spec[:start_date],
             "end-date"    => @data_spec[:end_date],
             "sort"        => @data_spec[:sort],
             "key"         => @account[:google_api_key],
             "ids"         => @account[:ga_profile_id]}.to_query
    #debug("query", query)
    URI GA_CORE_REPORTING_API_URL + '?' + query
  end

  def iso_date(date_id)
    year  = date_id / 10000
    month = "%02d" % ((date_id / 100) % 100)
    day   = "%02d" % (date_id % 100)
    "#{year}-#{month}-#{day}"
  end

  def debug(msg, data)
    if @debug
      print "\nDEBUG: #{msg}: "
      if data.respond_to?(:size)
        ap data
        puts "(size: #{data.size}): "
      else
        print "#{data}\n"
      end
    end
  end

end
