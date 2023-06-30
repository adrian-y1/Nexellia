class ProfilesController < ApplicationController
  def edit
    @profile = Profile.find(params[:id])
    @user = User.find(params[:user_id])
    if current_user != @user
      redirect_to root_path, alert: "404! The page you requested was not found."
    end
  end

  def update
    @profile = Profile.find(params[:id])
    @user = User.find(params[:user_id])

    # Store the original picture object in an instance variable
    @original_picture = @profile.picture.blob if @profile.picture.attached?

    respond_to do |format|
      if @profile.update(profile_params)
        update_profile_picture
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

  # destroy user's current profile image if they checked the box
  # else, attach their selected image
  def update_profile_picture
    picture = params[:profile][:picture]
    if params[:profile][:default] == "1"
      @profile.picture.purge
    else
      @profile.picture.attach(picture) if picture.present?
    end
  end

  def profile_params
    params.require(:profile).permit(:user_id, :first_name, :last_name, :gender, :bio_description, :public_email, :public_phone_number, :picture, :cover_photo, :default)
  end
end
