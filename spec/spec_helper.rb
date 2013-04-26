$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vim/unbundle'

RSpec::Matchers.define :include_bundle do |name, filetype = nil|
  match do |actual|
    actual.bundles.any? { |b| b.name == name && b.filetype == filetype }
  end
end

