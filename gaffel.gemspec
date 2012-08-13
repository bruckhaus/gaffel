# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gaffel/version"

Gem::Specification.new do |s|
  s.name              = "gaffel"
  s.version           = Gaffel::VERSION
  s.authors           = ["Tilmann Bruckhaus"]
  s.email             = 'tilmann@bruckha.us'
  s.homepage          = 'http://rubygems.org/gems/gaffel'
  s.summary           = %q{Extract data from Google Analytics (GA) v3.0 API}
  s.description       = %q{Extract data from Google Analytics (GA) version 3.0 Google APIs.
Supports extracting 1 metric for 0 or more dimensions, with start and end dates, sorting, and max results requested per
API call.  Provides results record-by-record via an each iterator.}
  s.rubyforge_project = "gaffel"
  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths     = ["lib"]
  s.add_development_dependency "rspec"
end
