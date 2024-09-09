class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :check_additional_info, except: [:additional_info, :save_additional_info]
    before_action :check_pet_info, unless: :devise_controller?, except: [:additional_info, :save_additional_info]
    helper_method :prefectures_with_cities

    def prefectures_with_cities
     json_path = Rails.root.join("public/prefectures_with_cities.json")
     json_data = File.read(json_path)
     JSON.parse(json_data)
   end
 
     protected

     def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :age)}

          devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :age, :password, :current_password, :username, :prefecture, :city, :own_pet)}
     end


     def authenticate_user_or_admin!
          if user_signed_in? || admin_signed_in?
               return true
          else
               redirect_to new_user_session_path
          end

     end

     def check_pet_info
          if user_signed_in? && current_user.own_pet? && !current_user.pets.present?
               redirect_to new_pet_path
          end
     end
   
     def check_additional_info
       if user_signed_in? && !current_user.additional_info_completed?
         redirect_to additional_info_path
       end
     end

end
