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

    context 'with the name ,the filetype, the revision' do

      subject(:bundle) { Bundle.new(name: 'foo/bar', filetype: :ruby, revision: '1.0.0') }

      it 'sets the name' do
        expect(bundle.name).to eq('foo/bar')
      end

      it 'sets the filetype' do
        expect(bundle.filetype).to eq(:ruby)
      end

      it 'sets the revision' do
        expect(bundle.revision).to eq('1.0.0')
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
          FileUtils.mkdir_p(File.join(dir, 'bundle', 'bar'))
          Dir.chdir(dir) do
            expect(bundle.installed?).to be_true
          end
        end
      end
    end

  end

  describe '#working_directory?' do

    context 'when the bundle is git working directory' do
      subject(:bundle) { Bundle.new(name: 'foo/bar') }

      it 'returns true' do
        tmpdir('vimfiles') do |dir|
          FileUtils.mkdir_p File.join(dir, 'bundle')
          g = Git.init(File.join(dir, 'bundle', 'bar'))
          g.commit('Initial commit', allow_empty: true)
          Dir.chdir(dir) do
            expect(bundle.working_directory?).to be_true
          end
        end
      end
    end

    context 'when the bundle is not git working directory' do
      subject(:bundle) { Bundle.new(name: 'foo/bar') }

      it 'returns false' do
        tmpdir('vimfiles') do |dir|
          FileUtils.mkdir_p File.join(dir, 'bundle', 'bar')
          Dir.chdir(dir) do
            expect(bundle.working_directory?).to be_false
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
          g = Git.open(File.join(dir, 'bundle', 'testrepo'))
          expect(g.object('HEAD').sha).to eq(g.log(1).first.sha)
        end
      end
    end

    context 'when has the sha revision' do
      subject(:bundle) { Bundle.new(name: 'hara/testrepo', revision: '4d9942') }

      it 'clones the repository and checkout' do
        tmpdir('vimfiles') do |dir|
          Dir.chdir(dir) do
            bundle.install
          end
          g = Git.open(File.join(dir, 'bundle', 'testrepo'))
          expect(g.object('HEAD').sha).to eq('4d994241c6c6dca9b85bd9b54ceffce28d3aa70a')
        end
      end
    end

    context 'when has the tag revision' do
      subject(:bundle) { Bundle.new(name: 'hara/testrepo', revision: '0.0.1') }

      it 'clones the repository and checkout' do
        tmpdir('vimfiles') do |dir|
          Dir.chdir(dir) do
            bundle.install
          end
          g = Git.open(File.join(dir, 'bundle', 'testrepo'))
          expect(g.object('HEAD').sha).to eq('4d994241c6c6dca9b85bd9b54ceffce28d3aa70a')
        end
      end
    end

    context 'when has already been installed' do
      subject(:bundle) { Bundle.new(name: 'hara/testrepo') }

      it 'clones the repository' do
        tmpdir('vimfiles') do |dir|
          FileUtils.mkdir_p File.join(dir, 'bundle', 'testrepo')
          Dir.chdir(dir) do
            bundle.install
          end
          expect(File.exist?(File.join(dir, 'bundle', 'testrepo', 'README.md'))).to be_false
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
          expect(File.exist?(File.join(dir, 'ftbundle', 'ruby', 'testrepo', 'README.md'))).to be_true
        end
      end
    end

  end

  describe '#update' do
    context 'when is not installed' do
      subject(:bundle) { Bundle.new(name: 'foo/testrepo') }

      it 'does not do nothing' do
        tmpdir('vimfiles') do |dir|
          Dir.chdir(dir) do
            bundle.update
          end
          expect(Dir.exist?(File.join(dir, 'bundle', 'testrepo', '.git'))).to be_false
        end
      end
    end

    context 'when has been installed as directory' do
      subject(:bundle) { Bundle.new(name: 'foo/testrepo') }

      it 'does not do nothing' do
        tmpdir('vimfiles') do |dir|
          FileUtils.mkdir_p File.join(dir, 'bundle', 'testrepo')
          Dir.chdir(dir) do
            bundle.update
          end
          expect(Dir.exist?(File.join(dir, 'bundle', 'testrepo', '.git'))).to be_false
        end
      end
    end

    context 'when has been installed as working dir' do

      context 'when fetch is required' do

        subject(:bundle) { Bundle.new(name: 'foo/testrepo') }

        it 'pulls and checkout' do
          tmpdir('vimfiles') do |dir|
            # setup remote repository
            origin = testrepo('testrepo', dir)

            # setup bundle repository
            bundle_dir = File.join(dir, 'bundle')
            FileUtils.mkdir_p bundle_dir
            repo = Git.clone(origin.dir.path, 'testrepo', path: bundle_dir)

            # update origin repository
            update_testrepo(origin)

            Dir.chdir(dir) do
              bundle.update
            end
            expect(repo.object('HEAD').sha).to eq(origin.object('HEAD').sha)
          end
        end
      end

      context 'when fetch is not required' do

        subject(:bundle) { Bundle.new(name: 'foo/testrepo') }

        it 'pulls and checkout' do
          tmpdir('vimfiles') do |dir|
            # setup remote repository
            origin = testrepo('testrepo', dir)
            expected_sha = origin.object('HEAD').sha

            # setup bundle repository
            bundle_dir = File.join(dir, 'bundle')
            FileUtils.mkdir_p bundle_dir
            repo = Git.clone(origin.dir.path, 'testrepo', path: bundle_dir)

            # update origin repository
            update_testrepo(origin)

            bundle.revision = '0.0.1'
            Dir.chdir(dir) do
              bundle.update
            end
            expect(repo.object('HEAD').sha).to eq(expected_sha)
          end
        end
      end

    end

  end

end
