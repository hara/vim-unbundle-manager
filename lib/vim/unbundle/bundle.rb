# coding: utf-8
require 'fileutils'
require 'git'

module Vim

  module Unbundle

    class Bundle
      # The String name of the bundle.
      attr_accessor :name

      # The Symbol filetype of the bundle.
      attr_accessor :filetype

      # The String revision of the bundle.
      attr_accessor :revision

      # Initializes a new Bundle.
      #
      # options - The Hash of initialization options
      def initialize(options = {})
        self.name     = options[:name] if options.key?(:name)
        self.filetype = options[:filetype] if options.key?(:filetype)
        self.revision = options[:revision] if options.key?(:revision)
      end

      # Gets the repository path.
      #
      # Returns the String path of the repository.
      def repository
        self.name.include?('/') ?
          'https://github.com/' + self.name + '.git' :
          'https://github.com/vim-scripts/' + self.name + '.git'
      end

      # Whether the bundle has alread been installed.
      #
      # Returns true if the bundle has been installed.
      def installed?
        Dir.exist?(dir)
      end

      # Installs the bundle.
      #
      # The bundle is installed to:
      #   <pwd>/bundles/<dir> (bundles)
      #   <pwd>/ftbundles/<filetype>/<dir> (ftbundles)
      #
      # vimdir - The String directory to locate bundle directory (ex. ~/.vim).
      #          Default: ~/vimfiles (Windows) or ~/.vim (UNIX like OS).
      def install
        return if installed?
        FileUtils.mkdir_p bundles_dir
        g = Git.clone(repository, short_name, path: bundles_dir)
        unless revision.nil?
          g.checkout(revision)
        end
      end

      # Gets the short name.
      #
      # Returns the String short name.
      def short_name
        name.split('/').last
      end

      private

      # Gets the path of the directory to locate bundles.
      def bundles_dir
        if filetype.nil?
          File.expand_path('bundle')
        else
          File.join(File.expand_path('ftbundle'), filetype.to_s)
        end
      end

      # Gets the bundle directory.
      def dir
        File.join(bundles_dir, short_name)
      end

    end

  end

end
