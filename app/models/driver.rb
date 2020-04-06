class Driver < ApplicationRecord

	def has_routes(id)
		where_clause= 'routes.driver_id = ? AND routes.data_ora_partenza > NOW()'
		routes = Stage.joins(:route).joins(:journey).select('routes.*').where(where_clause, id)
		if routes != nil
			false
		else
			true
		end
	end

	has_one  :user
	has_many :vehicles, dependent: :destroy
	has_many :reviews, dependent: :destroy
	has_many :ratings, dependent: :destroy
	has_many :routes
end
