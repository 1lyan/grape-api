class Project < ApplicationRecord
  belongs_to :client

  STATUSES = {
    started: 1,
    completed: 2
  }

  enum status: STATUSES
end
