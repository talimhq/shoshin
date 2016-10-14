module ApplicationHelper
  def gravatar_url(email = nil)
    if email
      "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?d=identicon"
    else
      "https://www.gravatar.com/avatar/000?d=mm"
    end
  end

  def class_for_result(result)
    if result.nil?
      'empty'
    elsif result
      'success'
    else
      'error'
    end
  end

  def material_icon_for(boolean=false)
    if boolean
      material_icon.check.css_class('icon-success')
    else
      material_icon.close.css_class('icon-error')
    end
  end

  def current_user
    current_account.user
  end

  def group_message_url_for_user(user, group)
    return teacher_group_messages_path(group) if user.is_a?(Teacher)
    return student_group_messages_path(group) if user.is_a?(Student)
  end

  def present(object, klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
