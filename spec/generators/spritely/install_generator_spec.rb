require 'spec_helper'
require 'generators/spritely/install_generator'

describe Spritely::Generators::InstallGenerator, :generator do
  destination File.expand_path("../../../../tmp", __FILE__)

  before do
    prepare_destination
    run_generator
  end

  subject { destination_root }

  it { is_expected.to have_structure {
    file '.gitignore' do
      contains 'app/assets/images/sprites'
    end
  } }
end
