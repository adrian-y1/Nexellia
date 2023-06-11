module ProfilesHelper
  def profile_picture_for(profile, size=50)
    if profile.picture.attached? && profile.picture.representable?
      begin
        profile.picture.representation(resize_to_limit: [100, 100]).processed
      rescue ActiveStorage::FileNotFoundError
        gravatar_url_for(profile.user.email, size)
      end
    else
      gravatar_url_for(profile.user.email, size)
    end
  end

  def gravatar_url_for(email, size)
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://secure.gravatar.com/avatar/#{hash}?s=#{size}&d=mm"
  end

  def cover_photo_for(profile)
    if profile.cover_photo.attached?
      profile.cover_photo.representation(resize_to_limit: [1200, 415]).processed
    else
      'default_cover_photo.jpg'
    end
  end

  def display_attribute_data(attribute)
    if attribute.present?
      attribute
    else
      "Not Provided"
    end
  end

  def attribute_provided?(attribute)
    attribute.present?
  end
end
