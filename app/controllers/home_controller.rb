class HomeController < ApplicationController
  before_action :check

  def index
    current = Company.where(:start_time=>{:$lte=>DateTime.now+5.hours+30.minutes}, :end_time=>{:$gte=>DateTime.now+5.hours+30.minutes}).to_a
    @companies = []
    current.each do |c|
      @companies << {u_id: c.u_id,company_type: c.company_type, name:c.name,offer: c.offer,description: c.description,departments: c.departments,intern: c.intern,placement:c.placement}
    end
  end

  def register
    # check conditions and make registration
    data = {}
    if user_signed_in?
      roll_no = current_user.roll_no
      year = roll_no.split("/").first.to_i
      company = Company.find_by(u_id: params[:company_uid])
      if (year==15 and company.intern) or (year==14 and company.placement)
        if current_user.placed_at.blank?
          if company.departments.include?(current_user.dept)
            r=Registration.where(user_id: current_user._id,company_id: company._id)
            if r.blank?
              new_registration = Registration.new
              dept = current_user.dept
              puts year
              if year == 15
                new_registration.type = "intern"
              else
                new_registration.type = "placement"
              end
              new_registration.user = current_user
              new_registration.company = company
              if new_registration.save
  	    		    data[:status] = "OK"
  	  		    else
  	     		    data[:status] = "error"
  			 		    data[:status] = "save error"
  		 		    end
            else
              data[:status] = "error"
              data[:reason] = "Already Registered"
            end
          else
            data[:status] = "error"
            data[:reason] = "Ineligible Department"
          end
        else
         data[:status] = "error"
         data[:reason] = "Already got an offer"
        end
      else
        data[:status] = "error"
        data[:reason] = "Ineligible year"
      end
    else
      data[:status] = "error"
      data[:reason] = "Not logged in"
    end
    respond_to do |format|
      format.json { render json: data }
    end
  end

end
