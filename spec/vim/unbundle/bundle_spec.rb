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

  describe '#short_name' do

    context 'when github user repo' do
      subject(:bundle) { Bundle.new(name: 'foo/bar') }
      it 'returns user repo short name' do
        expect(bundle.short_name).to eq('bar')
      end
    end

    context 'when github vim-scripts repo' do
      subject(:bundle) { Bundle.new(name: 'foo') }
      it 'returns vim-scripts repo short name' do
        expect(bundle.short_name).to eq('foo')
      end
    end

  end

  describe '#installed?' do

    context 'when is not installed' do
      subject(:bundle) { Bundle.new(name: 'foo/bar') }

      it 'returns false' do
        tmpdir('vimfiles') do |dir|
          Dir.chdir(dir) do
            expect(bundle.installed?).to be_false
          end
        end
      end
    end

    context 'when has already been installed' do
      subject(:bundle) { Bundle.new(name: 'foo/bar') }

      it 'returns true' do
        tmpdir('vimfiles') do |dir|
          FileUtils.mkdir_p(File.join(dir, 'bundles', 'bar'))
          Dir.chdir(dir) do
            expect(bundle.installed?).to be_true
          end
        end
      end
    end

  end

  describe '#install' do

    context 'when is not installed' do
      subject(:bundle) { Bundle.new(name: 'hara/testrepo') }

      it 'clones the repository' do
        tmpdir('vimfiles') do |dir|
          Dir.chdir(dir) do
            bundle.install
          end
          expect(File.exist?(File.join(dir, 'bundles', 'testrepo', 'README.md'))).to be_true
        end
      end
    end

    context 'when has already been installed' do
      subject(:bundle) { Bundle.new(name: 'hara/testrepo') }

      it 'clones the repository' do
        tmpdir('vimfiles') do |dir|
          FileUtils.mkdir_p File.join(dir, 'bundles', 'testrepo')
          Dir.chdir(dir) do
            bundle.install
          end
          expect(File.exist?(File.join(dir, 'bundles', 'testrepo', 'README.md'))).to be_false
        end
      end
    end

    context 'when ftbundle' do
      subject(:bundle) { Bundle.new(name: 'hara/testrepo', filetype: :ruby) }

      it 'clones the repository' do
        tmpdir('vimfiles') do |dir|
          Dir.chdir(dir) do
            bundle.install
          end
          expect(File.exist?(File.join(dir, 'ftbundles', 'ruby', 'testrepo', 'README.md'))).to be_true
        end
      end
    end

  end

end
