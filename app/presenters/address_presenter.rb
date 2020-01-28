class AddressPresenter < ApplicationPresenter
  presents :address

  # Methods delegated to Presented Class Address object's address
  @delegation_methods = [ :line1, :city, :state, :country, :pincode ]

  delegate *@delegation_methods, to: :address

  # Start the methods
  # def full_name
  #   first_name + last_name
  # end

  def full_address
    line1 + city + state + country + pincode
  end
end
