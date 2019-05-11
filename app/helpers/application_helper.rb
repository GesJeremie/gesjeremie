module ApplicationHelper
  include ActionView::Helpers::AssetTagHelper

  def page_title
    return @page_title.presence || 'Senior Full-Stack Developer — Ges Jeremie'
  end

  def digest(cache_key)
    Digest::MD5.hexdigest(cache_key)
  end

  def config
    Rails.configuration
  end
end
