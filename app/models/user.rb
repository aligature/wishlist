class User < ActiveRecord::Base
   include LastChanged

   # Include default devise modules. Others available are:
   devise :trackable, :omniauthable, :omniauth_providers => [:google_oauth2]


   has_many :list_users, :class_name => 'ListUser'
   has_many :lists, through: :list_users
   has_many :family_users, :class_name => 'FamilyUser'
   has_many :families, through: :family_users
   has_one :user_note
   has_many :addresses
   has_many :emails
   has_many :phone_numbers

   after_save :set_last_changed

   def save_as_view(session)
      session[:view_user_id] = id()
   end

   def self.view_user(session)
      return find(session[:view_user_id])
   end

   def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:username => data["email"]).first
      return user
   end

   def display_name
      "#{name} (#{username})"
   end

   def check_permissions(user)
      families.each do |family|
         if family.check_permissions(user)
            return true
         end
      end
      return false
   end

   def first_name
      name.split(" ")[0]
   end


   def email_required?
      false
   end

   def email_changed?
      false
   end

   def password_required?
      false
   end

   def password_match?
      true
   end

   def set_last_changed
      touch :last_change_time
      families.each do |family|
         family.set_last_changed
      end
   end

end
