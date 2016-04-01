require 'spec_helper'

describe MoviesController do

  before :each do
    @fake_movie = stub('double').as_null_object
    @movie = [mock('movie1')]
  end

  describe 'updating movie info' do
    before :each do
      movie_id = 5
      Movie.should_receive(:find).with(movie_id.to_s).and_return(@fake_movie)
      @fake_movie.should_receive(:update_attributes!).exactly 1
      put :update, {:id => movie_id, :movie => @movie}
  end

  it 'should redirect to details template for rendering' do
    response.should redirect_to(movie_path @fake_movie)
  end

  it 'should make updated info available to template' do
    assigns(:movie).should == @fake_movie
  end

end

#----------------------------------------------------
  describe 'finding movies by same director' do
  before :each do
    @movie_id = 10
    @founded = [mock('a movie'), mock('another one')]
    @fake_movie.stub(:director).and_return('fake director')
  end

  it 'should render samedirector view' do
    Movie.stub(:find).and_return(@fake_movie)
    Movie.stub(:find_all_by_director).and_return(@founded)

    get :samedirector, {:id => @movie_id}
    response.should render_template 'samedirector'
  end

  it 'should redirect home if no director info' do
    empty_director = double('movie', :director => '').as_null_object
    Movie.stub(:find).and_return(empty_director)
    Movie.stub(:find_all_by_director)

    get :samedirector, {:id => @movie_id}
    response.should redirect_to(movies_path)
    end
  end

#---------------------------------------------------
  describe 'delete an existing movie' do
    it 'should call a model method to update data' do
      my_movie = mock('a movie').as_null_object

      Movie.should_receive(:find).and_return(my_movie)
      my_movie.should_receieve(:destroy)
      delete :destroy, {:id => 1}
    end

    
  end

#-----------------------------------------------------
  describe 'Create a new movie' do
  
  it 'should render the new movie template' do
    get :new
    response.should render_template 'new'
  end

  it 'should call a model method to store the data' do
    movie = stub("new movie").as_null_object
    Movie.should_receive(:create!).and_return(movie)
    post :create, {:movie => movie}

    response.should redirect_to(movies_path)
  end

  end
end

