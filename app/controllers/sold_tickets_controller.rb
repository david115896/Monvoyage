class SoldTicketsController < ApplicationController
  before_action :set_sold_ticket, only: [:show, :edit, :update, :destroy]

  # GET /sold_tickets
  # GET /sold_tickets.json
  def index
    @sold_tickets = SoldTicket.all
  end

  # GET /sold_tickets/1
  # GET /sold_tickets/1.json
  def show
  end

  # GET /sold_tickets/new
  def new
    @sold_ticket = SoldTicket.new
  end

  # GET /sold_tickets/1/edit
  def edit
  end

  # POST /sold_tickets
  # POST /sold_tickets.json
  def create
    @sold_ticket = SoldTicket.new(sold_ticket_params)

    respond_to do |format|
      if @sold_ticket.save
        format.html { redirect_to @sold_ticket, notice: 'Sold ticket was successfully created.' }
        format.json { render :show, status: :created, location: @sold_ticket }
      else
        format.html { render :new }
        format.json { render json: @sold_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sold_tickets/1
  # PATCH/PUT /sold_tickets/1.json
  def update
    respond_to do |format|
      if @sold_ticket.update(sold_ticket_params)
        format.html { redirect_to @sold_ticket, notice: 'Sold ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @sold_ticket }
      else
        format.html { render :edit }
        format.json { render json: @sold_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sold_tickets/1
  # DELETE /sold_tickets/1.json
  def destroy
    @sold_ticket.destroy
    respond_to do |format|
      format.html { redirect_to sold_tickets_url, notice: 'Sold ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sold_ticket
      @sold_ticket = SoldTicket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sold_ticket_params
      params.fetch(:sold_ticket, {})
    end
end
