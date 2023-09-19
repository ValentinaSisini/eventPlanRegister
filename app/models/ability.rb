class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new 

    if user.organizer? 
      # Solo gli organizzatori possono gestire gli eventi (ognuno solo i suoi)
      can :manage, Event, user:user
      # Gli organizzatori possono vedere e cancellare le partecipazioni relative agli eventi da loro organizzati
      can [:read, :destroy], Participation, event: { user_id: user.id }
      # Gli organizzatori possono vedere solo le loro notifiche
      can :read, Notification, user:user
      # 

    elsif user.participant? 
      # I partecipanti possono vedere tutti gli eveti
      can :read, Event
      # I partecipanti possono gestire ognono le proprie prenotazioni ad eventi
      can :manage, Participation, user:user
      # I partecipanti possono vedere solo le loro notifiche
      can :read, Notification, user:user

    else
      cannot :read, [Event, Participation, Notification]
    end

  end
end
