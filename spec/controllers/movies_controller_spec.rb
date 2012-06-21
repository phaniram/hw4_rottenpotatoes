require 'spec_helper'

describe MoviesController do
  describe 'fucntionality:- should be able to ' do
    it 'create a movie' do
      movie = mock('Movie')
      movie.stub!(:title)
      
      Movie.should_receive(:create!).and_return(movie)
      post :create, {:movie => movie}
      response.should redirect_to(movies_path)
    end
    it 'destroy a movie' do
      movie = mock('Movie')
      movie.stub!(:title)
      Movie.should_receive(:find).with('5').and_return(movie)
      movie.should_receive(:destroy)
      post :destroy, {:id => '5'}
      response.should redirect_to(movies_path)
    end
    it 'show page for the Movie ' do
      mock = mock('Movie')
      Movie.should_receive(:find).with("5").and_return(mock)
      get :show,{:id=>'5'}
      response.should render_template("show")
    end
    it 'edit page for the Movie' do
      mock = mock('Movie')
      Movie.should_receive(:find).with("5").and_return(mock)
      get :edit,{:id=>'5'}
      response.should render_template("edit")
    end

    it 'redirect if sort order has been changed' do
      session[:sort] = 'release_date'
      get :index, {:sort => 'title'}
      response.should redirect_to(movies_path(:sort => 'title'))
    end
    
    it 'order by release date' do
      get :index, {:sort => 'release_date'}
      response.should redirect_to(movies_path(:sort => 'release_date'))
    end
    
    it 'redirect if selected ratings are changed' do
      get :index, {:ratings => {:G => 1}}
      response.should redirect_to(movies_path(:ratings => {:G => 1}))
    end

    it 'get movies from db' do
      Movie.should_receive(:all_ratings)
      Movie.should_receive(:find_all_by_rating)
      get :index
    end
    
    it 'update page for the Movie' do
      mock = mock('Movie')
      mock.stub!(:update_attributes!)
      mock.stub!(:title)
      
      Movie.should_receive(:find).with('5').and_return(mock)
      mock.should_receive(:update_attributes!)
      post :update,{:id=>'5',:movie=>mock}
      response.should redirect_to(movie_path(mock))
    end
    
    it 'And I fill in "Director" with "Ridley Scott", And  I press "Update Movie Info", it should save the director' do
      mock = mock('Movie')
      mock.stub!(:update_attributes!)
      mock.stub!(:title)
      mock.stub!(:director)

      mock2 = mock('Movie')

      Movie.should_receive(:find).with('5').and_return(mock)
      mock.should_receive(:update_attributes!)
      post :update, {:id => '5', :movie => mock2 }
      response.should redirect_to(movie_path(mock))
    end
    it 'When I follow "Find Movies With Same Director", I should be on the Similar Movies page for the Movie' do
      mock=mock('Movie')
      mock.stub!(:director).and_return('mock director')
      
      mocks=[mock('Movie'), mock('Movie')]

      Movie.should_receive(:find).with('5').and_return(mock)
      Movie.should_receive(:where).with('director =? AND id !=?',mock.director,'5').and_return(mocks)
      mock.should_receive(:director)
      get :similar, {:id => '5'}
      response.should render_template("similar")
    end
    it 'should redirect to index if movie does not have a director' do
      mock = mock('Movie')
      mock.stub!(:director).and_return('')
      mock.stub!(:title).and_return('')

      Movie.should_receive(:find).with('5').and_return(mock)
      mock.should_receive(:director)
      get :similar, {:id => '5'}
      response.should redirect_to(movies_path)
    end

  end
  
end
