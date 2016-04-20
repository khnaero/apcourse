class Location < ActiveRecord::Base
	belongs_to :user
	has_many :photos, :dependent => :destroy

	validates :name,
						presence: true,
						length: { minimum: 3, maximum: 50 },
						uniqueness: true

	validates :latitude,
						presence: true,
						numericality: true,
						length: { minimum: 7}

	validates :longitude,
						presence: true,
						numericality: true,
						length: { minimum: 8}

	validates :equipment,
						presence: true,
						length: { minimum: 5, maximum: 500 }
end
