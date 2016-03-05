class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:sort_by].nil? && params[:ratings].nil? &&
        (!session[:sort_by].nil? || !session[:ratings].nil?)
        redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    end

    @sort_column = params[:sort_by]
    @ratings = params[:ratings]
        if @ratings.nil?
            ratings = Movie.ratings
        else
	    ratings = @ratings.keys
      	end


    @all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
	all_ratings[rating] = @ratings.nil? ? false : @ratings.has_key?(rating)
	all_ratings
    end

    if !@sort_column.nil?
        begin
	    @movies = Movie.where(rating: ratings).order(params[:sort_by])
        rescue ActiveRecord::StatementInvalid
            flash[:warning] = "Movies cannot be sorted by #{sort_column}!"
            @movies = Movie.where(rating: ratings)
        end
    else
        @movies = Movie.where(rating: ratings)
    end

    session[:ratings] = @ratings
    session[:sort_by] = @sort_column
    
 end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

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

end
