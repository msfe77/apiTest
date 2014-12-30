class CompaniesController < ApplicationController
  def index
    @tasks = Company.all
    render json: @tasks
  end

  #GET /companies/1
  #GET /companies/1.json
  def show
    @company = Company.find (params[:id])
    #@tasks = Task.where(:id=>params[:id]).where(:name=>params[:name])
    # Busqueda por nombre de compañía
    #@tasks = Task.find_by_name(params[:id])
    render json: @company
  end

end
