class TasksController < ApplicationController

  #before_filter :restrict_access


  #GET /tasks
  #GET /task.json
  def index
    #sql = "SELECT * FROM tasks "
    #@tasks = ActiveRecord::Base.connection.execute(sql)
    #@tasks = Task.all
    #render json: @tasks
  end

  <<-CMNT
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
  CMNT

  #POST /create/tasks/GNP
  def create

    <<-JO
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
    JO


    @user = params[:task]
    @pass = params[:pass]
    @idType = params[:idType]
    @idCompany = params[:idCompany]
    @type = params[:kindQuery]

    sql = "SELECT COUNT(*) FROM tasks WHERE name = '" + @user + "' AND token='" + @pass + "'"
    @valor = ActiveRecord::Base.connection.execute(sql)
    @value = @valor.first.first[1]

    if Integer(@value) > 0

    if @type == '1'

    sql = "SELECT t.name as Type, c.name as Company FROM tasks t, companies c WHERE c.id =" + @idCompany + " AND t.id=" + @idType
    @tasks = ActiveRecord::Base.connection.execute(sql)
    #@tasks = Task.all
    render json: @tasks

    else

      sql = "INSERT INTO tasks(name, token, created_at, updated_at)
    VALUES ( '" + @user + "','" + @pass + "', current_timestamp, current_timestamp)"
      @task = ActiveRecord::Base.connection.execute(sql)
      #@task = Task.new(params[:task])

    end

    else

    end

  end


<<-DK
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
DK

  <<-SK
  def restrict_access
    api_key = Task.find_by_token(params[:token])
    head :unauthorized unless api_key
  end
  SK

  <<-SUPERSECURE
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      Task.exists?(token: token)
    end
  end
  SUPERSECURE


end