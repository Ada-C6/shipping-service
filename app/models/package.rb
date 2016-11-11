class Package < ActiveRecord::Base
  validates :state, presence: true
  validates :city, presence: true
  validates :zip, presence: true, length: { minimum: 5 , maximum: 5}
  # validates_length_of :zip, :minimum => 5, :maximum => 5
  validates :weight, presence: true
end
