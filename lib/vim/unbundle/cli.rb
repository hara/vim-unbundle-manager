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

      desc 'clean', 'Clean undefined bundles'
      method_option :force, type: :boolean, default: false, aliases: '-f', desc: 'clean without confirmation'
      def clean
        force = options[:force]
        bundlefile = load_bundlefile
        if force
          bundlefile.clean do |bundle|
            say cleaning_message(bundle)
            true
          end
        else
          bundlefile.clean { |bundle| ask("Remove #{File.basename bundle}?", limited_to: ['y', 'n']) == 'y' }
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
        "Installing #{bundle.short_name}" +
          (bundle.revision.nil? ? '' : " (#{bundle.revision})")
      end

      # Gets the String 'Updating bundle (rev)' message.
      def updating_message(bundle)
        "Updating #{bundle.short_name}" +
          (bundle.revision.nil? ? '' : " (#{bundle.revision})")
      end

      # Gets the String 'Cleaning bundle' message.
      def cleaning_message(dir)
        "Cleaning #{File.basename(dir)}"
      end
    end

  end

end
