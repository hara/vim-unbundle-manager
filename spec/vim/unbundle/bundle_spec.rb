# coding: utf-8
require_relative '../../spec_helper'

include Vim::Unbundle

describe Bundle do

  describe '.new' do

    context 'with the name' do

      subject(:bundle) { Bundle.new(name: 'foo/bar') }

      it 'sets the name' do
        expect(bundle.name).to eq('foo/bar')
      end

      it 'does not set the filetype' do
        expect(bundle.filetype).to be_nil
      end

    end

    context 'with the name and the filetype' do

      subject(:bundle) { Bundle.new(name: 'foo/bar', filetype: :ruby) }

      it 'sets the name' do
        expect(bundle.name).to eq('foo/bar')
      end

      it 'sets the filetype' do
        expect(bundle.filetype).to eq(:ruby)
      end

    end

  end

  describe '#repository' do

    context 'when github user reso' do
      subject(:bundle) { Bundle.new(name: 'foo/bar') }
      it 'returns user repo path' do
        expect(bundle.repository).to eq('https://github.com/foo/bar.git')
      end
    end

    context 'when github vim-scripts reso' do
      subject(:bundle) { Bundle.new(name: 'foo') }
      it 'returns vim-scripts repo path' do
        expect(bundle.repository).to eq('https://github.com/vim-scripts/foo.git')
      end
    end

  end

end
