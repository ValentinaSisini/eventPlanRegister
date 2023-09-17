class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new 

    if user.organizer? 
      # solo gli organizatori possono gestire gli eventi (ognuno solo i suoi)
      can :manage, Event, user:user

      # Gli organizzatori possono vedere e cancellare le partecipazioni relative agli eventi da loro organizzati
      can [:read, :destroy], Participation, event: { user_id: user.id }

    elsif user.participant? 
      # i partecipanti possono vedere tutti gli eveti
      can :read, Event
      # i partecipanti possono gestire ognono le proprie prenotazioni ad eventi
      can :manage, Participation, user:user

    else
      cannot :read, [Event, Participation]
    end

  end
end
