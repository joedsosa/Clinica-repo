module ApplicationHelper
  def flash_class(level)
    {
      notice: 'alert alert-primary',
      success: 'alert alert-success',
      error: 'alert alert-danger',
      alert: 'alert alert-warning'
    }[level.to_sym]
  end
end
