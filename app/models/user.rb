class User < ApplicationRecord
  validates :first_name, :last_name, :salary, presence: true
end
