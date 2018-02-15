class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  # def initialize
  #   @all_ratings = Movie.all_ratings
  #   @all_ratings = ['G','PG','PG-13','R']
  #   super
  # end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index 
    #@movies = Movie.all 
    @sort_by = params[:sort] || session[:sort]
    @ratings = params[:ratings] || session[:ratings]
    #first launch, session sort is empty and param sort might be empty, and as you choose to sort, they get data and they will remember
    
    if @ratings.nil?
      ratings = Movie.ratings
    else
      ratings = @ratings.keys
      # keys that we put in the Movie.rb with p, pg, pg-13...
    end
      
    if !@sort_by.nil?
      @movies = Movie.order("#{@sort_by} ASC").where(:rating => ratings)
    else
      @movies = Movie.where(:rating => ratings)
    end 
    
    @all_ratings = Movie.ratings.inject(Hash.new) do | all_ratings, rating |
      all_ratings[rating] = @ratings.nil? ? false : @ratings.has_key?(rating)
      all_ratings
    end
    
    #This is where we are remembering it now:
    session[:sort] = @sort_by
    session[:ratings] = @ratings
    
    if params[:sort].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?)
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
  end 
#order is saying put it in this order, by ascending order
#if statement is making sure that the database is not empty 

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
  #flash keeps track of particular information
  #params, sessions not hashes

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  # def hilight(column)
  #   if(session[:order].to_s == column)
  #     return 'hilite'
  #   else
  #     return nil
  #   end
  # end
end
