class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy toggle_status ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.order(created_at: :desc)
    @task = Task.new
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    render @task, locals: { editing: params[:editing] }
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.turbo_stream
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "task_form",
            partial: "form",
            locals: { task: @task }
          )
        }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
          format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            @task,
            partial: "tasks/task",
            locals: { task: @task }
          )
        end
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            @task,
            partial: "tasks/task",
            locals: { task: @task, editing: true }
          )
        }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_status
    next_status = case @task.status
    when "pending" then "in_progress"
    when "in_progress" then "completed"
    else "pending"
    end

    @task.update(status: next_status)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @task }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.expect(task: [ :title, :description, :status ])
    end
end
