$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vim/unbundle'

RSpec::Matchers.define :include_bundle do |name, options = {}|
  match do |actual|
    actual.bundles.any? do |b|
      b.name == name &&
        b.filetype == options[:filetype] &&
        b.revision == options[:revision]
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

# Creates a temporary directory and processes the block with the directory.
def tmpdir(prefix_suffix = nil, &block)
  Dir.mktmpdir(prefix_suffix) do |dir|
    block.call(dir)
  end
end

# Creates a temporary directory and processes the block in the directory.
def in_tmpdir(prefix_suffix = nil, &block)
  Dir.mktmpdir(prefix_suffix) do |dir|
    Dir.chdir(dir) do
      block.call(dir)
    end
  end
end

# Creates a test git repository.
#
# name - The String name of the repository.
# dir  - The String dir in which the repository will be created.
#
# Returns the Git::Base repository.
def testrepo(name, dir)
  repo = Git.init File.join(dir, name)
  repo.chdir do
    File.write 'README.md', 'initial'
    repo.add('README.md')
  end
  repo.commit 'Initial commit'
  repo.add_tag('0.0.1')
  repo
end

# Updates the test repository.
#
# repo - The Git::Base test repository.
def update_testrepo(repo)
  repo.chdir do
    File.write 'README.md', 'second'
    repo.add('README.md')
  end
  repo.commit 'Second commit'
  repo.add_tag('0.0.2')
  repo
end

