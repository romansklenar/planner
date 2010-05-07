module BugsHelper

  # Return CSS class(es) for task, eg. "completed" for completed tasks
  def css_class_for_bug(bug)
    out  = ''
    out += 'completed' if bug.closed?
    return out
  end
end
