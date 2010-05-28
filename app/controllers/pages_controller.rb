class PagesController < ApplicationController

# We see here that pages controller.rb defines a class called PagesController. Functions are
# actions like the home and contact actions, which are defined using the def keyword. 
# The angle bracket < indicates that PagesController inherits from the Rails class ApplicationController

# In plain Ruby, these methods would simply do nothing. In Rails, the situation is different; PagesController
# is a Ruby class, but because it inherits from ApplicationController the behavior of its methods
# is specific to Rails: when visiting the URL /pages/home, Rails looks in the Pages controller and executes
# the code in the home action, and then renders the view corresponding to
# the action. In the present case, the home action is empty, so all hitting /pages/home does is render the view.

# The at sign @ in @title indicates that it is an instance variable. Any instance variable defined in
# the home action is automatically available in the home.html.erb view.

  def home
  	@title = "Home"
  end

  def contact
  	@title = "Contact"
  end
  
  def about
  	@title = "About"
  end
  
  def help
    	@title = "Help"
  end
  
end
