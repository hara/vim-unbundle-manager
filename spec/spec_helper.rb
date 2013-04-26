$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vim/unbundle'

RSpec::Matchers.define :include_bundle do |name, filetype = nil|
  match do |actual|
    actual.bundles.any? { |b| b.name == name && b.filetype == filetype }
  end
end

# Creates a temporary home directory and processes the block in the directory.
#
# name  - The String prefix of the directory.
# block - The Block to process.
def homedir(name = nil, &block)
  Dir.mktmpdir(name) do |home|
    begin
      old_home = ENV['HOME']
      ENV['HOME'] = home
      block.call(home)
    ensure
      ENV['HOME'] = old_home
    end
  end
end

# Creates a temporary file and call the block with the file.
#
# basename - The String temporary file base name.
# content  - The String content of the file.
# block    - The Block to process.
def tempfile(basename, content, &block)
  file = Tempfile.new(basename)
  begin
    file.puts content
    file.close
    block.call(file)
  ensure
    file.unlink
  end
end

# Creates a temporary directory and processes the block in the directory.
def tmpdir(prefix_suffix = nil, &block)
  Dir.mktmpdir(prefix_suffix) do |dir|
    block.call(dir)
  end
end

