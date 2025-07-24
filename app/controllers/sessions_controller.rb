class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new callback failure]

  def new; end

  def callback
    # start session from OmniAuth payload
    DfeSignInUser.begin_session!(session, request.env["omniauth.auth"])

    if current_user
      current_user.update!(last_signed_in_at: Time.current)
      redirect_to after_sign_in_path, notice: "Signed in successfully"
    else
      DfeSignInUser.end_session!(session)
      redirect_to after_sign_out_path, flash: {
        heading: "Cannot sign in",
        success: false
      }
    end
  end

  def destroy
    # end session and redirect to root path. Should be expanded to conditionally head to dfe sign out path in future.
    DfeSignInUser.end_session!(session)
    redirect_to root_path
  end

  def failure
    dfe_sign_in_uid = session.dig("dfe_sign_in_user", "dfe_sign_in_uid")
    Rails.logger.warn("DSI failure with #{params[:message]} for dfe_sign_in_uid: #{dfe_sign_in_uid}")
    DfeSignInUser.end_session!(session)

    redirect_to main_app.internal_server_error_path, alert: "Sign-in failed"
  end
end
