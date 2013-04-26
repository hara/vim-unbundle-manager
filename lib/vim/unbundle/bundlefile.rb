# -*- coding: utf-8 -*-

module Vim

  module Unbundle

    class Bundlefile
      # Finds the Bundlefile.
      #
      # Returns the String path.
      def self.find
        Dir[
          File.expand_path('~/vimfiles/Bundlefile'),
          File.expand_path('~/.vim/Bundlefile'),
        ].first
      end

      # Loads the Bundlefile from the <path>.
      # When called without <path>, finds Bundlefile
      # by `Bundlefile.find` and loads it.
      #
      # path - The String file path to load.
      #
      # Returns the Bundlefile.
      def self.load(path = nil)
        path ||= find
        return nil if path.nil? || !File.exist?(path)

        instance = Bundlefile.new
        instance.load(path)
        instance
      end

      # Get defined bundles.
      attr_reader   :bundles

      # Initializes a new Bundlefile.
      def initialize
        @bundles = []
        @filetypes = [nil]
      end

      # Loads the definition file.
      #
      # path - The String path of the definition file.
      def load(path)
        instance_eval File.read(path, encoding: 'UTF-8'), path
      end

      # Defines a bundle.
      def bundle(name)
        bundle = Bundle.new(name: name,
                            filetype: current_filetype)
        self.bundles << bundle
      end

      # Defines a filetype scope.
      def filetype(ft, &block)
        begin
          @filetypes.push ft
          instance_eval &block
        ensure
          @filetypes.pop
        end
      end

      private

      # Get the current filetype scope.
      def current_filetype
        @filetypes.last
      end

    end

  end

end
