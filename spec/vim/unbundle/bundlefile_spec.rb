# -*- coding: utf-8 -*-
require_relative '../../spec_helper'

include Vim::Unbundle

describe Bundlefile do

  describe '#bundle' do
    subject(:bundlefile) { Bundlefile.new }

    context 'with a name' do
      it 'defines a new bundle' do
        bundlefile.bundle 'foo/bar'
        expect(bundlefile.bundles.first.name).to eq('foo/bar')
      end
    end

  end

  describe '#filetype' do
    subject(:bundlefile) { Bundlefile.new }

    context 'with a filetype' do
      it 'defines a ftbundle' do
        bundlefile.filetype(:ruby) { bundle 'foo/bar' }
        expect(bundlefile.bundles.first.filetype).to eq(:ruby)
      end
    end

  end

end
