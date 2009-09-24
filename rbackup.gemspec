# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rbackup}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Winton Welsh"]
  s.date = %q{2009-09-24}
  s.default_executable = %q{rbackup}
  s.email = %q{mail@wintoni.us}
  s.executables = ["rbackup"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["bin", "bin/rbackup", "gemspec.rb", "lib", "lib/rbackup.rb", "MIT-LICENSE", "Rakefile", "rbackup.gemspec", "README.markdown", "spec", "spec/fixtures", "spec/fixtures/destination", "spec/fixtures/rbackup.yml", "spec/fixtures/source", "spec/fixtures/source/1.txt", "spec/fixtures/source/2.txt", "spec/fixtures/source/3.txt", "spec/rbackup_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/winton/rbackup}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Backup your stuff with Ruby and Rsync}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
