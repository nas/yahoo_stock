Gem::Specification.new do |s|
  s.name = %q{yahoo_stock}
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nasir Jamal"]
  s.date = %q{2009-08-31}
  s.description = %q{Yahoo Stock is a Ruby library for extracting information about stocks from yahoo finance}
  s.email = %q{nas35_in@yahoo.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["History.txt", "README.rdoc", "Manifest.txt", "Rakefile", "lib/yahoo_stock.rb", "lib/yahoo_stock/quote.rb", "lib/yahoo_stock/interface.rb", "spec/*"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/nas/yahoo_stock}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Yahoo Stock is a Ruby library for extracting information about stocks from yahoo finance.}
  s.test_files = Dir["spec/*_spec.rb"]
  s.platform = Gem::Platform::RUBY 
  s.required_ruby_version = '>=1.8' 
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mime-types>, [">= 1.15"])
      s.add_runtime_dependency(%q<diff-lcs>, [">= 1.1.2"])
    else
      s.add_dependency(%q<mime-types>, [">= 1.15"])
      s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<mime-types>, [">= 1.15"])
    s.add_dependency(%q<diff-lcs>, [">= 1.1.2"])
  end
end
