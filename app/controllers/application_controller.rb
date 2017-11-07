class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def check
    if user_signed_in?
      fields = current_user.attributes.keys
      fields -= %w{_id encrypted_password sign_in_count roles_mask single_placed mass_placed
                reset_password_token reset_password_sent_at remember_created_at sign_in_count u_id placed_at c_at
                current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip}
      fields.each do |field|
        if current_user[field].blank? and current_user.roles_mask != 1
          flash[:notice] = "Fill this form to proceed"
          redirect_to force_update_url
          break
        end
      end
    end
  end
end
