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

    let(:bundlefile) do
      bundlefile = Bundlefile.new
      bundlefile.bundle 'foo/defined_bundle'
      bundlefile.filetype :ruby do
        bundlefile.bundle 'foo/defined_ftbundle'
      end
      bundlefile
    end

    let(:dotvim) { Dir.mktmpdir('.vim') }
    let(:defined_bundle) { File.join(dotvim, 'bundle', 'defined_bundle')}
    let(:undefined_bundle) { File.join(dotvim, 'bundle', 'undefined_bundle')}
    let(:defined_ftbundle) { File.join(dotvim, 'ftbundle', 'ruby', 'defined_ftbundle')}
    let(:undefined_ftbundle) { File.join(dotvim, 'ftbundle', 'ruby', 'undefined_ftbundle')}

    shared_context 'in .vim' do
      before do
        FileUtils.mkdir_p dotvim
        FileUtils.mkdir_p defined_bundle
        FileUtils.mkdir_p undefined_bundle
        FileUtils.mkdir_p defined_ftbundle
        FileUtils.mkdir_p undefined_ftbundle
      end

      after do
        FileUtils.remove_entry_secure dotvim
      end
    end

    shared_examples 'clean bundles' do
      it 'removes undefined bundles' do
        expect(Dir.exist?(undefined_bundle)).to be_false
      end

      it 'does not remove defined bundles' do
        expect(Dir.exist?(defined_bundle)).to be_true
      end

      it 'removes undefined ftbundles' do
        expect(Dir.exist?(undefined_ftbundle)).to be_false
      end

      it 'does not remove defined ftbundles' do
        expect(Dir.exist?(defined_ftbundle)).to be_true
      end
    end

    context 'without block' do
      include_context 'in .vim'

      before do
        Dir.chdir(dotvim) { bundlefile.clean }
      end

      include_examples 'clean bundles'
    end

    context 'with a block' do
      include_context 'in .vim'

      it 'yields undefined bundle path' do
        Dir.chdir(dotvim) do
          expect { |b| bundlefile.clean(&b) }.to yield_successive_args(undefined_bundle, undefined_ftbundle)
        end
      end

    end

    context 'with a block returns true' do
      include_context 'in .vim'

      before do
        Dir.chdir(dotvim) { bundlefile.clean { true } }
      end

      include_examples 'clean bundles'
    end

    context 'with a block which does not true' do
      include_context 'in .vim'

      before do
        Dir.chdir(dotvim) { bundlefile.clean { false } }
      end

      it 'does not remove undefined bundles' do
        expect(Dir.exist?(undefined_bundle)).to be_true
      end

      it 'does not remove defined bundles' do
        expect(Dir.exist?(defined_bundle)).to be_true
      end

      it 'does not removes undefined ftbundles' do
        expect(Dir.exist?(undefined_ftbundle)).to be_true
      end

      it 'does not remove defined ftbundles' do
        expect(Dir.exist?(defined_ftbundle)).to be_true
      end

    end

  end

end
