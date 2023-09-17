class ParticipationsController < ApplicationController
  include CanCan::ControllerAdditions
  before_action :authenticate_user!, :set_participation, only: %i[ show edit update destroy ]
  load_and_authorize_resource


  # GET /participations or /participations.json
  def index
    #@participations = Participation.all
    @participations = Participation.where(user_id: current_user.id).includes(:event, :user)
  end

  # GET /participations/1 or /participations/1.json
  def show
    @events = Event.all # Ottiene tutti gli eventi disponibili
  end

  # GET /participations/new
  def new
    @participation = Participation.new
    @events = Event.all # Ottiene tutti gli eventi disponibili
  end

  # GET /participations/1/edit
  def edit
    @events = Event.all # Ottiene tutti gli eventi disponibili
  end

  # POST /participations or /participations.json
  def create
    @participation = Participation.new(participation_params)

    @participation.user = current_user # Imposta l'utente corrente come assegnatoario della prenotazione

    @events = Event.all # Ottiene tutti gli eventi disponibili

    respond_to do |format|
      if @participation.save
        format.html { redirect_to participation_url(@participation), notice: "Participation was successfully created." }
        format.json { render :show, status: :created, location: @participation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participations/1 or /participations/1.json
  def update
    respond_to do |format|
      if @participation.update(participation_params)
        format.html { redirect_to participation_url(@participation), notice: "Participation was successfully updated." }
        format.json { render :show, status: :ok, location: @participation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participations/1 or /participations/1.json
  def destroy
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to participations_url, notice: "Participation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participation
      @participation = Participation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def participation_params
      params.require(:participation).permit(:user_id, :event_id)
    end
end
