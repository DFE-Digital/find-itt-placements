module OrganisationRedirectable
  extend ActiveSupport::Concern

  def redirect_to_organisation(user, organisation_id = nil)
    if user.admin?
      redirect_to admin_dashboard_index_path, notice: "Signed in as #{user.first_name} #{user.last_name}"
      return
    end

    organisation = if organisation_id
        user.organisations.find_by(id: organisation_id)
    elsif user.organisations.one?
        user.organisations.first
    end

    if organisation.present?
      user.update!(selected_organisation: organisation)
      notice = organisation_id ? "You have changed your organisation to #{organisation.name}" : "Signed in as #{user.first_name} #{user.last_name}"

      path = if organisation.is_a?(School) && organisation.placement_preferences.blank?
               new_add_hosting_interest_placement_preferences_path(organisation)
      elsif organisation.is_a?(School)
               placement_preferences_path
      else
               organisations_path
      end
      redirect_to path, notice:
    else
      alert = organisation_id ? "You do not have access to this organisation." : nil
      redirect_to change_organisation_index_path, alert:
    end
  end
end
