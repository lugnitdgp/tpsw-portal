class AddOfferController < ApplicationController

  def placed
    # You can access submitted params (just submit your form to the dashboard).
      roll_nos = params[:roll_nos].split(" ")
      company = Company.find_by(name:params[:company])
      roll_nos.each do |roll_no|
        year = roll_no.split("/").first.to_i
        student = User.find_by(roll_no: roll_no)
        if year == 14
          if company.company_type == "Mass"
            student.mass_placed = company.u_id
          else
            student.single_placed = company.u_id
          end
        else
          student.mass_placed = company.u_id
          student.single_placed = company.u_id
        end
        student.save
      end
      flash[:notice] = "Offer added"
      redirect_to rails_admin_path
  end
end
