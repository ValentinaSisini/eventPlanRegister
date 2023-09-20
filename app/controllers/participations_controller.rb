class ParticipationsController < ApplicationController
  include CanCan::ControllerAdditions
  before_action :authenticate_user!, :set_participation, only: %i[ show edit update destroy ]
  load_and_authorize_resource


  # GET /participations or /participations.json
  def index
    if current_user.organizer?
      @participations = Participation.joins(:event).where(events: { user_id: current_user.id }).includes(:event, :user)
    else
      @participations = Participation.where(user_id: current_user.id).includes(:event, :user)
    end
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
    @participation.user = current_user # Imposta l'utente corrente come assegnatario della prenotazione
    @event = @participation.event # ricava l'evento associato alla partecipazione

    @events = Event.all # Ottiene tutti gli eventi disponibili

    respond_to do |format|
      # 0 - Se l'evento non è stato specificato:
      # Restituisce errore
      if !@event.present? 
        @participation.errors.add(:base, "Please select an event.")
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      # 1 - Se l'aggiunta della nuova partecipazione NON PROVOCA il raggiungimento della campienza massima:
      # Salva normalmente la nuova partecipazione
      elsif @event.participations.count < (@event.max_participants - 1)
        if @participation.save
          format.html { redirect_to participation_url(@participation), notice: "Participation was successfully created." }
          format.json { render :show, status: :created, location: @participation }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @participation.errors, status: :unprocessable_entity }
        end
      
      # 2 - Altrimenti, se l'aggiunta della nuova partecipazione PROVOCA il raggiungimento della campienza massima:
      # Salva la nuova partecipazione E INVIA LA NOTIFICA ALL'ORGANIZZATORE
      elsif @event.participations.count == (@event.max_participants - 1)
        if @participation.save
          format.html { redirect_to participation_url(@participation), notice: "Participation was successfully created." }
          format.json { render :show, status: :created, location: @participation }
          # Invia notifica all'organizzatore
          message = "The event #{@event.name} has reached the maximum number of participants."
          Notification.create(user: @event.user, event: @event, message: message, datetime: Time.now)
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @participation.errors, status: :unprocessable_entity }
        end
      
      # 3 - Altrimenti, se la quota massima E' GIA' STATA RAGGIUNTA
      # Blocca il salvataggio della nuova partecipazione
      else
        @participation.errors.add(:base, "The event has reached its maximum capacity.")
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

    # Notifica al partecipante che è stato rimosso dall'evento
    message = "Your participation in the event #{@participation.event.name} has been canceled."
      Notification.create(user: @participation.user, event: @participation.event, message: message, datetime: Time.now)

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
