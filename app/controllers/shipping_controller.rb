require 'active_shipping'

class ShippingController < ApplicationController
  def quote
    packages = [
  ActiveShipping::Package.new(100,
                              [93,10],           
                              cylinder: true),

  ActiveShipping::Package.new(7.5 * 16,          # 7.5 lbs, times 16 oz/lb.
                              [15, 10, 4.5],     # 15x10x4.5 inches
                              units: :imperial)  # not grams, not centimetres
 ]

   # Make "package" and 'origin'
   # Call Active shipping





   # LOG, save the params and response
  end
end
