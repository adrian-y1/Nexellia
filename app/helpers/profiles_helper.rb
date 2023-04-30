module ProfilesHelper
  def profile_picture_for(profile, size=50)
    if profile.picture.attached? && profile.picture.representable?
      profile.picture.representation(resize_to_limit: [100, 100]).processed
    else
      hash = Digest::MD5.hexdigest(profile.user.email.downcase)
      "https://secure.gravatar.com/avatar/#{hash}?s=#{size}&d=robohash"
    end
  end
end
