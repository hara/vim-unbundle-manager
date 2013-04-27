# coding: utf-8
require 'thor'

module Vim

  module Unbundle

    class CLI < Thor
      include Thor::Actions

      desc 'install', 'Install bundles'
      def install
        bundlefile = Bundlefile.load('Bundlefile')
        raise Thor::Error, 'Cannot find Bundlefile' if bundlefile.nil?

        bundlefile.bundles.each do |bundle|
          if bundle.installed?
            say "Using #{bundle.short_name}"
            next
          end

          say "Installing #{bundle.short_name}'"
          bundle.install
        end
      end

    end

  end

end
