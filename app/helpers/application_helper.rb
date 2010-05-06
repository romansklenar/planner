# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def css_class_for_content
    current_user ? 'fleft' : 'fnone'
  end

  def css_class_for_sidebar_li(options = {})
    current_page?(options) ? "active" : ''
  end
end
