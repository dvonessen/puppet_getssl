require 'spec_helper'
describe 'getssl' do
  context 'with default values for all parameters' do
    it { should contain_class('getssl') }
  end
end
