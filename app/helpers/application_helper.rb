module ApplicationHelper
  include Pagy::Frontend
  include ActionView::RecordIdentifier

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "layouts/flash"
  end

  def nested_dom_id(parent, child)
    "#{dom_id(parent)}_#{dom_id(child)}"
  end
end
