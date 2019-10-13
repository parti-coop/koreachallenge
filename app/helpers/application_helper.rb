module ApplicationHelper
  def bootstrap_style?
    !current_page?('/privacy') and
    !current_page?('/terms')
  end

  def body_class
    dasherized_controller_name = params[:controller].gsub(/\//, '--')
    arr = ["app-#{dasherized_controller_name}", "app-#{dasherized_controller_name}-#{params[:action]}"]
    arr.join(' ')
  end

  def static_day_f(date)
    date.strftime("%Y.%m.%d")
  end

  def human_datetime_f(date)
    date.strftime("%Y년 %m월 %d일 %H:%M")
  end

  def is_kakao_talkable?
    browser.device.mobile?
  end

  def excerpt(text, options = {})
    return text if text.blank?

    options[:length] = 130 unless options.has_key?(:length)
    result = strip_tags(text)
    return result if result.blank?

    result = HTMLEntities.new.decode(result)
    return result.truncate(options[:length], options)
  end
end
