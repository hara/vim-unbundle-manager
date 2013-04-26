# -*- coding: utf-8 -*-
require_relative '../../spec_helper'
require 'tempfile'
require 'tmpdir'
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
          expect(bundlefile).to include_bundle('foo/baz', :ruby)
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

end
