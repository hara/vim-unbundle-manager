# -*- coding: utf-8 -*-
require_relative '../../spec_helper'
require 'fileutils'

include Vim::Unbundle

describe Bundlefile do
  let(:definition) do <<-EOS
    bundle 'foo/bar'
    filetype :ruby do
      bundle 'foo/baz'
    end
  EOS
  end

  describe '#bundle' do
    subject(:bundlefile) { Bundlefile.new }

    context 'with a name' do
      it 'defines a new bundle' do
        bundlefile.bundle 'foo/bar'
        expect(bundlefile).to include_bundle('foo/bar')
      end
    end

    context 'with a name and a revision' do
      it 'defines a new bundle' do
        bundlefile.bundle 'foo/bar', '1.0.0'
        expect(bundlefile).to include_bundle('foo/bar', revision: '1.0.0')
      end
    end

  end

  describe '#filetype' do
    subject(:bundlefile) { Bundlefile.new }

    context 'with a filetype' do
      it 'defines a ftbundle' do
        bundlefile.filetype(:ruby) { bundle 'foo/bar' }
        expect(bundlefile).to include_bundle('foo/bar', filetype: :ruby)
      end
    end

  end

  describe '#load' do
    context 'with a Bundlefile path' do

      it 'defines bundles from Bundlefile' do
        tempfile('Bundlefile', definition) do |file|
          bundlefile = Bundlefile.new
          bundlefile.load(file.path)
          expect(bundlefile).to include_bundle('foo/bar')
        end
      end

      it 'defines ftbundles from Bundlefile' do
        tempfile('Bundlefile', definition) do |file|
          bundlefile = Bundlefile.new
          bundlefile.load(file.path)
          expect(bundlefile).to include_bundle('foo/baz', filetype: :ruby)
        end
      end
    end
  end

  describe '.load' do

    context 'when Bundlefile exists in ~/vimfiles' do
      it 'returns Bundlefile' do
        tempfile('Bundlefile', definition) do |file|
          expect(Bundlefile.load(file.path)).to include_bundle('foo/bar')
        end
      end
    end

    context 'when Bundlefile does not exist' do
      it 'returns Bundlefile' do
        tmpdir('vimfiles') do |dir|
          expect(Bundlefile.load(File.join(dir, 'Bundlefile'))).to be_nil
        end
      end
    end
  end

  describe '#clean' do

    subject(:bundlefile) do
      bundlefile = Bundlefile.new
      bundlefile.bundle 'foo/defined_bundle'
      bundlefile.filetype :ruby do
        bundlefile.bundle 'foo/defined_ftbundle'
      end
      bundlefile
    end

    it 'removes undefined bundles' do
      in_tmpdir('vimfiles') do |dir|
        undefined = File.join(dir, 'bundle', 'undefined_bundle')
        FileUtils.mkdir_p undefined
        bundlefile.clean
        expect(Dir.exist?(undefined)).to be_false
      end
    end

    it 'does not remove defined bundles' do
      in_tmpdir('vimfiles') do |dir|
        defined = File.join(dir, 'bundle', 'defined_bundle')
        FileUtils.mkdir_p defined
        bundlefile.clean
        expect(Dir.exist?(defined)).to be_true
      end
    end

    it 'removes undefined ftbundles' do
      in_tmpdir('vimfiles') do |dir|
        undefined = File.join(dir, 'ftbundle', 'ruby', 'undefined_ftbundle')
        FileUtils.mkdir_p undefined
        bundlefile.clean
        expect(Dir.exist?(undefined)).to be_false
      end
    end

    it 'does not remove defined ftbundles' do
      in_tmpdir('vimfiles') do |dir|
        defined = File.join(dir, 'ftbundle', 'ruby', 'defined_ftbundle')
        FileUtils.mkdir_p defined
        bundlefile.clean
        expect(Dir.exist?(defined)).to be_true
      end
    end

  end

end
