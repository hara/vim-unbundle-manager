# -*- coding: utf-8 -*-
require_relative '../../spec_helper'
require 'tempfile'
require 'tmpdir'
require 'fileutils'

include Vim::Unbundle

describe Bundlefile do

  describe '.find' do

    context 'when Bundlefile exists in ~/vimfiles' do

      it 'returns ~/vimfiles/Bundlefile' do
        Dir.mktmpdir('john') do |home|
          FileUtils.mkdir_p File.join(home, 'vimfiles')
          FileUtils.touch File.join(home, 'vimfiles', 'Bundlefile')
          begin
            old_home = ENV['HOME']
            ENV['HOME'] = home
            expect(Bundlefile.find).to eq(File.join(home, 'vimfiles', 'Bundlefile'))
          ensure
            ENV['HOME'] = old_home
          end
        end
      end

    end

    context 'when Bundlefile exists in ~/.vim' do

      it 'returns ~/.vim/Bundlefile' do
        Dir.mktmpdir('john') do |home|
          FileUtils.mkdir_p File.join(home, '.vim')
          FileUtils.touch File.join(home, '.vim', 'Bundlefile')
          begin
            old_home = ENV['HOME']
            ENV['HOME'] = home
            expect(Bundlefile.find).to eq(File.join(home, '.vim', 'Bundlefile'))
          ensure
            ENV['HOME'] = old_home
          end
        end
      end

    end

    context 'when does not exists' do

      it 'returns ~/.vim/Bundlefile' do
        Dir.mktmpdir('john') do |home|
          FileUtils.mkdir_p File.join(home, 'vimfiles')
          FileUtils.mkdir_p File.join(home, '.vim')
          begin
            old_home = ENV['HOME']
            ENV['HOME'] = home
            expect(Bundlefile.find).to be_nil
          ensure
            ENV['HOME'] = old_home
          end
        end
      end

    end

  end

  describe '#bundle' do
    subject(:bundlefile) { Bundlefile.new }

    context 'with a name' do
      it 'defines a new bundle' do
        bundlefile.bundle 'foo/bar'
        expect(bundlefile).to include_bundle('foo/bar')
      end
    end

  end

  describe '#filetype' do
    subject(:bundlefile) { Bundlefile.new }

    context 'with a filetype' do
      it 'defines a ftbundle' do
        bundlefile.filetype(:ruby) { bundle 'foo/bar' }
        expect(bundlefile).to include_bundle('foo/bar', :ruby)
      end
    end

  end

  describe '#load' do
    context 'with a Bundlefile path' do

      before :all do
        @file = Tempfile.new('Bundlefile')
        @file.puts <<-EOS
        bundle 'foo/bar'
        filetype :ruby do
          bundle 'foo/baz'
        end
        EOS
        @file.close
      end

      after :all do
        @file.unlink
      end

      it 'defines bundles from Bundlefile' do
        bundlefile = Bundlefile.new
        bundlefile.load(@file.path)
        expect(bundlefile).to include_bundle('foo/bar')
      end

      it 'defines ftbundles from Bundlefile' do
        bundlefile = Bundlefile.new
        bundlefile.load(@file.path)
        expect(bundlefile).to include_bundle('foo/baz', :ruby)
      end
    end
  end

  describe '.load' do

    context 'when Bundlefile exists in ~/vimfiles' do

      it 'returns Bundlefile' do
        Dir.mktmpdir('john') do |home|
          FileUtils.mkdir_p File.join(home, 'vimfiles')
          File.write File.join(home, 'vimfiles', 'Bundlefile'), <<-EOS
          bundle 'foo/bar'
          filetype :ruby do
            bundle 'foo/baz'
          end
          EOS
          begin
            old_home = ENV['HOME']
            ENV['HOME'] = home
            expect(Bundlefile.load).to include_bundle('foo/bar')
          ensure
            ENV['HOME'] = old_home
          end
        end
      end

    end

    context 'when Bundlefile does not exist' do

      it 'returns Bundlefile' do
        Dir.mktmpdir('john') do |home|
          FileUtils.mkdir_p File.join(home, 'vimfiles')
          begin
            old_home = ENV['HOME']
            ENV['HOME'] = home
            expect(Bundlefile.load).to be_nil
          ensure
            ENV['HOME'] = old_home
          end
        end
      end

    end
  end

end
