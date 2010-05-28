require 'md5'
require 'active_support/secure_random'

class UsersController < ApplicationController
  
  include AuthenticatedSystem
  
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

  # render new.rhtml
  def new
  if @facebook_session.nil?
      @user = User.new
  else
     @user = User.new(":birthday(1i)" =>"1960", :first_name => facebook_session.user.first_name , :last_name => facebook_session.user.last_name , :fb_user_id => facebook_session.user.uid, :password => "", :email => "", :fb_img => facebook_session.user.pic)
  end
    @title = "Sign Up"
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.gender = params[:gender]
        	
    
    if !@facebook_session.nil?
	    @user.fb_user_id = facebook_session.user.uid
	    @user.fb_img = facebook_session.user.pic
	    @user.invitetoken = MD5.md5(ActiveSupport::SecureRandom.hex(16)).hexdigest
    end	
    
    success = @user && @user.save

    if success && @user.errors.empty?
      if !@user.parenttoken.nil?
      	@attr = { :invitetoken => @user.parenttoken }
      	@user.friends.create(@attr)
      end
      
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default('/')
      # flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "Darnit. Parts of your signup form are incorrect. Look for the red alerts below."
      render :action => 'new'
    end
  end
  
 def link_user_accounts
     if self.current_user.nil?
       #register with fb
       #User.create_from_fb_connect(facebook_session.user)
       # @user = User.new(:name => facebook_session.user.name, :login => "facebooker_#{facebook_session.user.uid}", :password => "", :email => "")
     else
       #connect accounts
       self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
       redirect_back_or_default('/')
       return
     end
     redirect_to '/signup'
  end

end
