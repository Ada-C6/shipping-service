class ShippingController < ApplicationController

end

# response I send should look like:
# [
# {"id": 1, "name": "UPS Ground", "cost": 20.41},
# {"id": 2, "name": "UPS Second Day Air", "cost": 82.71},
# {"id": 3, "name": "FedEx Ground", "cost": 20.17},
# {"id": 4, "name": "FedEx 2 Day", "cost": 68.46},
# ]
