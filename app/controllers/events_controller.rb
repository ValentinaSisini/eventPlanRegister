class EventsController < ApplicationController
  include CanCan::ControllerAdditions
  before_action :authenticate_user!, :set_event, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /events or /events.json
  def index
    @events = Event.all

    # Applica i filtri se sono stati forniti
    if params[:name].present?
      @events = @events.where("name LIKE ?", "%#{params[:name]}%")
    end

    if params[:start_datetime].present?
      @events = @events.where("start_datetime >= ?", params[:start_datetime])
    end

    if params[:latitude].present?
      @events = @events.where("latitude = ?", params[:latitude])
    end

    if params[:longitude].present?
      @events = @events.where("longitude = ?", params[:longitude])
    end

    # Ordina gli eventi per data di inzio
    @events = @events.order(start_datetime: :asc)

    # Mostra gli eventi nella vista
    render :index

  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    @event.user = current_user # Imposta l'utente corrente come creatore dell'evento

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:user_id, :name, :start_datetime, :end_datetime, :location, :max_participants, :latitude, :longitude)
    end
end
