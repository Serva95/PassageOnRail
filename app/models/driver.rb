class Driver < ApplicationRecord
	# Trova se eisistono route attive associate al driver
	def has_routes(id)
		where_clause= 'routes.driver_id = ? AND routes.data_ora_partenza > NOW() AND routes.deleted IS NOT TRUE'
		Route.select('routes.*').where(where_clause, id).exists?
	end

	def self.delete_driver(user, driver)
		self.transaction do
			user.update!(driver_id: nil)
			driver.destroy!
		end
	end

	has_one  :user
	has_many :vehicles, dependent: :destroy
	has_many :reviews, dependent: :destroy
	has_many :ratings, dependent: :destroy
	has_many :routes
end
