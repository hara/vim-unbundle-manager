# coding: utf-8

module Vim

  module Unbundle

    class Bundle
      # The String name of the bundle.
      attr_accessor :name
      # The Symbol filetype of the bundle.
      attr_accessor :filetype

      # Initializes a new Bundle.
      #
      # options - The Hash of initialization options
      def initialize(options = {})
        self.name     = options[:name] if options.key?(:name)
        self.filetype = options[:filetype] if options.key?(:filetype)
      end

      # Gets the repository path.
      #
      # Returns the String path of the repository.
      def repository
        self.name.include?('/') ?
          'https://github.com/' + self.name + '.git' :
          'https://github.com/vim-scripts/' + self.name + '.git'
      end

    end

  end

end
