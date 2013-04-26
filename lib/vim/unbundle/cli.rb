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
            say_status :skip, "'#{bundle.name}' has alread been installed"
            next
          end

          say "Installing '#{bundle.name}' ... "
          bundle.install
          say 'Done!'
        end
      end

    end

  end

end
