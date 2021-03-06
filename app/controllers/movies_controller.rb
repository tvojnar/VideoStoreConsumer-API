class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    # To access the external_id:
      # movie_params['external_id']
    movie = MovieWrapper.find(movie_params['external_id'])

    # book = Book.new(title: params[:book][:title], author: params[:book][:author])
    #    book.save
    #    redirect_to('/books')

    if movie.save
      render status: :ok, json: movie
    else
      # TODO: handle errors in a better way .... maybe make validations for Movie? 
      render json: {}
    end
    # render json: { ready_for_lunch: movie }
  end # create

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
# defines what params we will accept from the user when they make a post request to our api
  def movie_params
    params.require(:movie).permit(:external_id)
  end # movie_params
end
