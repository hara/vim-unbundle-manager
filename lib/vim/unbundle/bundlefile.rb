# -*- coding: utf-8 -*-

module Vim

  module Unbundle

    class Bundlefile
      # Get defined bundles.
      attr_reader   :bundles

      # Initializes a new Bundlefile.
      def initialize
        @bundles = []
        @filetypes = [nil]
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
