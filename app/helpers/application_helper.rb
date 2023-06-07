module ApplicationHelper
  include Pagy::Frontend
  include ActionView::RecordIdentifier

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def nested_dom_id(parent, child)
    "#{dom_id(parent)}_#{dom_id(child)}"
  end

  def set_active_link(path)
    is_current_path?(path) ? "active-link" : ""
  end

  def set_fill_icon(path)
    is_current_path?(path) ? "-fill" : ""
  end

  def set_active_border(path)
    is_current_path?(path) ? content_tag(:div, "", class: "active-link-border") : ""
  end

  def is_current_path?(path)
    request.path == path
  end

  def is_flash_notice?(flash_type)
    flash_type == "notice"
  end

  def flash_icon(flash_type)
    if is_flash_notice?(flash_type) 
      content_tag(:i, "", class: "bi bi-check-circle-fill")
    else
      content_tag(:i, "", class: "bi bi-x-circle-fill")
    end
  end
end
