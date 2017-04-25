class City < ActiveRecord::Base
  validates :name, presence: true
  validates :state, presence: true, length: { is: 2 }
end
