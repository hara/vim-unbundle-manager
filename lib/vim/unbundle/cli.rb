# coding: utf-8
require 'thor'

module Vim

  module Unbundle

    class CLI < Thor
      include Thor::Actions

      desc 'install', 'Install bundles'
      def install
        bundlefile = load_bundlefile

        bundlefile.bundles.each do |bundle|
          if bundle.installed?
            say using_message(bundle)
            next
          end

          say installing_message(bundle)
          bundle.install
        end
      end

      desc 'update', 'Update bundles'
      def update
        bundlefile = load_bundlefile

        bundlefile.bundles.each do |bundle|
          unless bundle.installed?
            say installing_message(bundle)
            bundle.install
            next
          end

          unless bundle.working_directory?
            say using_message(bundle)
            next
          end

          say updating_message(bundle)
          bundle.update
        end

      end

      private

      # Loads the 'Bundlefile'.
      def load_bundlefile
        file = Bundlefile.load('Bundlefile')
        raise Thor::Error, 'Cannot find Bundlefile' if file.nil?
        file
      end

      # Gets the String 'Using bundle (rev)' message.
      def using_message(bundle)
        "Using #{bundle.short_name}" +
          (bundle.revision.nil? ? '' : " (#{bundle.revision})")
      end

      # Gets the String 'Installing bundle (rev)' message.
      def installing_message(bundle)
        "Installing #{bundle.short_name}'" +
          (bundle.revision.nil? ? '' : " (#{bundle.revision})")
      end

      # Gets the String 'Updating bundle (rev)' message.
      def updating_message(bundle)
        "Updating #{bundle.short_name}'" +
          (bundle.revision.nil? ? '' : " (#{bundle.revision})")
      end

    end

  end

end
