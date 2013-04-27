# -*- coding: utf-8 -*-

module Vim

  module Unbundle

    class Bundlefile
      # Loads the Bundlefile from the <path>.
      #
      # path - The String Bundlefile path.
      #
      # Returns the Bundlefile.
      def self.load(path)
        return nil unless File.exist?(path)
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
      def bundle(name, revision = nil)
        bundle = Bundle.new(name: name,
                            filetype: current_filetype,
                            revision: revision)
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
