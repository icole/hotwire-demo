module TasksHelper
  def task_status_color(task)
    case task.status
    when "pending"
      "bg-yellow-600 hover:bg-yellow-700"
    when "in_progress"
      "bg-blue-600 hover:bg-blue-700"
    when "completed"
      "bg-green-600 hover:bg-green-700"
    end
  end
end
