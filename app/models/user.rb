require 'digest/sha1'
require 'md5'
require 'active_support/secure_random'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  
  validates_presence_of     :first_name,    :message => "Letters only. No numbers or little characters. Thanks!"
  validates_format_of       :first_name,    :with => Authentication.name_regex,  :message => Authentication.bad_name_message
  validates_length_of       :first_name,    :maximum => 100
  
  validates_presence_of     :last_name,    :message => "Letters only. No numbers or little characters. Thanks!"
  validates_format_of       :last_name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :last_name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => "^Please enter a valid e-mail address."

  
  validates_numericality_of :mobilephone, :only_integer => true, :message => "Numbers only. No letters or little characters. Thanks!"
  
   if !@facebook_session.nil?
  	  validates_attachment_presence :avatar
	  validates_attachment_size :avatar, :less_than => 5.megabytes
	  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png']
  end
  
  has_attached_file :avatar,
                    :url  => "/assets/users/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"
  
 
 

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :avatar, :invitetoken, :parenttoken, :first_name, :last_name, :gender, :mobilephone, :country,  :password, :password_confirmation, :fb_user_id, :fb_img, :birthday
  
  has_many :friends

  
  after_create :register_user_to_fb


  #find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    User.find_by_fb_user_id(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
  end
  
  #Take the data returned from facebook and create a new user from it.
  #We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.  
  def self.create_from_fb_connect(fb_user)
    new_facebooker = User.new(:name => fb_user.name, :login => "facebooker_#{fb_user.uid}", :password => "", :email => "")
    new_facebooker.fb_user_id = fb_user.uid.to_i
    #We need to save without validations
    new_facebooker.save(false)
    new_facebooker.register_user_to_fb
  end
  
  #We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_user_id)
    unless fb_user_id.nil?
      #check for existing account
      existing_fb_user = User.find_by_fb_user_id(fb_user_id)
      #unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.fb_user_id = nil
        existing_fb_user.save(false)
      end
      #link the new one
      self.fb_user_id = fb_user_id
      self.fb_img = existing_fb_user.fb_img
      self.invitetoken = MD5.md5(ActiveSupport::SecureRandom.hex(16)).hexdigest
      save(false)
    end
  end
  
  #The Facebook registers user method is going to send the users email hash and our account id to Facebook
  #We need this so Facebook can find friends on our local application even if they have not connect through connect
  #We then use the email hash in the database to later identify a user from Facebook with a local user
  def register_user_to_fb
    users = {:email => email, :account_id => id}
    Facebooker::User.register([users])
    self.email_hash = Facebooker::User.hash_email(email)
    save(false)
  end
  
  def facebook_user?
    return !fb_user_id.nil? && fb_user_id > 0
  end



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
    


end
