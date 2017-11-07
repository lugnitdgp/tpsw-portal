class UserController < ApplicationController

 before_action :check, only: [:profile]

 def update_form
   @blank_fields = []
   if user_signed_in?
     fields = current_user.attributes.keys
     fields -= %w{_id mass_placed single_placed encrypted_password sign_in_count roles_mask reset_password_token
            reset_password_sent_at remember_created_at sign_in_count u_id placed_at c_at
            current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip}
     fields.each do |field|
      # if any field is empty take it into account and pass to view
      @blank_fields << field if current_user[field].blank?
     end
   else
     redirect_to new_user_session_path
   end
   if @blank_fields.blank?
     redirect_to root_path
   end
 end

 def save_update
  restricted_fields = [ "_id" , "encrypted_password" , "sign_in_count" , "roles_mask" , "reset_password_token" ,
            "reset_password_sent_at" , "single_placed", "mass_placed", "remember_created_at" , "sign_in_count" , "u_id" , "placed_at" , "c_at",
            "current_sign_in_at"  , "last_sign_in_at" , "current_sign_in_ip" , "last_sign_in_ip" ]
  params[:user].each do |key,value|
    if restricted_fields.include?(key)
      next
    else
      if key == "sgpa"
        current_user[key]=value.split(" ")
      else
        current_user[key]=value unless value.blank?
      end

    end
  end
    if current_user.save
      redirect_to root_path
    else
      redirect_to force_update_path
    end
 end

 def profile
    fields = []
    if user_signed_in?
      fields = current_user.attributes.keys
      fields -= %w{_id encrypted_password mass_placed single_placed sign_in_count roles_mask reset_password_token
            reset_password_sent_at remember_created_at sign_in_count u_id placed_at
            current_sign_in_at last_sign_in_at current_sign_in_ip c_at last_sign_in_ip}
      @info = {}
      fields.each do |field|
        if field == "sgpa"
          @info[field] = current_user[field].join(" ")
        else
          @info[field] = current_user[field]
        end
      end
    else
      redirect_to root_path
    end
 end

end
