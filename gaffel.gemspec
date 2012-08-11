Gem::Specification.new do |s|
  s.name        = 'gaffel'
  s.version     = '0.0.2'
  s.date        = '2012-08-10'
  s.summary     = "Extract data from Google Analytics (GA) v3.0 API"
  s.description = "Supports extracting 1 metric for 0 or more dimensions, with start and end dates, " +
      "sorting, and max results requested per Google API call.  Provides results record-by-record via an iterator."
  s.authors     = ["Tilmann Bruckhaus"]
  s.email       = 'tilmann@bruckha.us'
  s.files       = ["lib/gaffel.rb"]
  s.homepage    = 'http://rubygems.org/gems/gaffel'
end