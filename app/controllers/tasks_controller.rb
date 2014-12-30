class TasksController < ApplicationController

  before_filter :restrict_access

  #GET /tasks
  #GET /task.json
  def index
    sql = "SELECT * FROM tasks "
    @tasks = ActiveRecord::Base.connection.execute(sql)
    #@tasks = Task.all
    render json: @tasks
  end

  #GET /tasks/1
  #GET /tasks/1.json
  def show
    @tasks = Task.find (params[:id])
    #@tasks = Task.where(:id=>params[:id]).where(:name=>params[:name])
    # Busqueda por nombre de compañía
    #@tasks = Task.find_by_name(params[:id])
    render json: @tasks
  end

  #GET /showBoth/tasks/1/1
  #GET /showBoth/tasks/1/1.json
  def showBoth

    @idTask = params[:id]
    @idCompany = params[:id]

    sql = "SELECT t.name as TASKS, c.name as COMPANY  FROM tasks t, companies c WHERE t.id=" + @idTask + "AND c.id=" + @idCompany
    @tasks = ActiveRecord::Base.connection.execute(sql)
    #@tasks = Task.where(:id=>params[:id]).where(:name=>params[:name])
    # Busqueda por nombre de compañía
    #@tasks = Task.find_by_name(params[:id])
    render json: @tasks
  end

  #GET /tasks/new
  #GET /tasks/new.json
  def new
    @tasks = Task.new
    render json: @tasks
  end

  #POST /create/tasks/GNP
  def create

    @nameTask = params[:task]
    sql = "INSERT INTO tasks(name, created_at, updated_at)
    VALUES ( '" + @nameTask + "', current_timestamp, current_timestamp)"
    @task = ActiveRecord::Base.connection.execute(sql)
    #@task = Task.new(params[:task])

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  #PATCH/PUT /tasks/1
  #PATCH/PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    if @task.update_attributes(params[:task])
      head :no_content
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    head :no_content
  end


  private

  def restrict_access
    api_key = Task.find_by_token(params[:token])
    head :unauthorized unless api_key
  end


end