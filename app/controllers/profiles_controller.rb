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
    
    # Store the original picture object in an instance variable
    @original_picture = @profile.picture.blob if @profile.picture.attached?
    
    respond_to do |format|
      if @profile.update(profile_params)
        attach_picture
        format.turbo_stream { flash.now[:notice] = "Profile information have been updated" }
        format.html { redirect_to user_path(@profile.user), notice: "Profile information have been updated" }
      else
        # Re-attach the original picture object to the profile object
        @profile.picture.attach(@original_picture) if @original_picture.present?
        format.html { render :edit, status: :unprocessable_entity, locals: { profile: @profile }, alert: "Error while updating profile" }
      end
    end
  end

  private

  def attach_picture
    picture = params[:profile][:picture]
    @profile.picture.attach(picture) if picture.present?
  end

  def profile_params
    params.require(:profile).permit(:user_id, :first_name, :last_name, :gender, :bio_description, :public_email, :public_phone_number, :picture)
  end
end
