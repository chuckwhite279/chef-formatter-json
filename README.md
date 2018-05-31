
gem build json-chef-formatter.gemspec
gem push json-chef-formatter-0.1.0.gem --host https://artifactory-dev.exacttarget.com/artifactory/api/gems/sfmc-ruby
/opt/chefdk/embedded/bin/gem install ./json-chef-formatter-0.1.0.gem