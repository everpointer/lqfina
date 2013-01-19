require 'spec_helper'

describe GroupBuy do
  subject(:business) { GroupBuy.new(dsr: 4.3) }

  its(:dsr_rate) { should eq 0.8 }
end
