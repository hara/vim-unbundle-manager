# -*- coding: utf-8 -*-
require_relative '../../spec_helper'
require 'tempfile'

include Vim::Unbundle

describe Bundlefile do

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

end
