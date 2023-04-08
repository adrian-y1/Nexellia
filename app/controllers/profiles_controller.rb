class ProfilesController < ApplicationController
  def edit
    @profile = Profile.find(params[:id])
    @user = User.find(params[:user_id])
    if current_user != @user
      redirect_to root_path, alert: "You can only edit your own profile."
    end
  end

  def update
    @profile = Profile.find(params[:id])
    @user = User.find(params[:user_id])

    respond_to do |format|
      if @profile.update(profile_params)
        format.turbo_stream { flash.now[:notice] = "Profile information have been updated" }
        format.html { redirect_to user_path(@profile.user), notice: "Profile information have been updated" }
      else
        format.html { render :edit, status: :unprocessable_entity, alert: "Error while updating profile" }
      end
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:user_id, :first_name, :last_name, :gender, :bio_description, :public_email, :public_phone_number)
  end
end
