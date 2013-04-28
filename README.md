# Unbundle Manager

Unbundle Manager manages bundles for [unbundle.vim](https://github.com/sunaku/vim-unbundle).

## Installation

Add this line to your application's Gemfile:

    gem 'vim-unbundle-manager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vim-unbundle-manager

## Usage

### Install bundles

1. Write bundle definition to `~/.vim/Bundlefile` as bellow.

	bundle 'matchit.zip'                     # github.com/vim-scripts/foo
	bundle 'tpope/vim-surround'              # github.com/user/foo
	bundle 'Shougo/neocomplcache', 'ver.7.2' # freeze bundle version
	
	# ftbundles
	filetype :ruby do
	  bundle 'vim-ruby/vim-ruby'
	end

2. Install bundles.

	$ cd ~/.vim
	$ unbundle install

### Update bundles

	$ cd ~/.vim
	$ unbundle update

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
