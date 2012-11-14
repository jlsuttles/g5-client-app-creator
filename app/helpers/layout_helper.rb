module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def header_right(header_right, show_header_right = true)
    content_for(:header_right) { raw(header_right) }
    @show_header_right = show_header_right
  end

  def show_header_right?
    @show_header_right
  end

  def flash_div(level)
    if flash[level].present?
      bootstrap_level = (level == notice ? "info" : level)
      content_tag "div", class: "alert alert-#{bootstrap_level}" do
        content_tag "p", flash[level]
      end
    end
  end
end
