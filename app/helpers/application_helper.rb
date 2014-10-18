module ApplicationHelper

   def user_breadcrumb(view_user, current_user, create_link)
      if view_user != current_user
         label = view_user.name
      else
         label = "me"
      end

      if create_link
         return link_to label, user_path(view_user)
      else
         return label
      end
   end

end
