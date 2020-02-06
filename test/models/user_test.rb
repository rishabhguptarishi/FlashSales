# == Schema Information
#
# Table name: users
#
#  id                                :bigint           not null, primary key
#  name                              :string(255)
#  email                             :string(255)
#  password_digest                   :string(255)
#  verified                          :boolean          default(FALSE)
#  verification_token                :string(255)
#  remember_me_token                 :string(255)
#  password_reset_token              :string(255)
#  password_reset_token_generated_at :datetime
#  verification_token_generated_at   :datetime
#  remember_me_token_generated_at    :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  role_id                           :bigint           default(1), not null
#  verified_at                       :datetime
#  stripe_customer_id                :string(255)
#  authentication_token              :string(255)
#  authentication_token_generated_at :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
