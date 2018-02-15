#do the business logic; goes into database and finds movie, make new variable THE MODEL FOR MOVIE
class Movie < ActiveRecord::Base
    def self.ratings
        ['G', 'PG', 'PG-13', 'R']
    end
end
