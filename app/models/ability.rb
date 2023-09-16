class Ability
  include CanCan::Ability

  def initialize(user)

    return unless user.present?
    # chiunque loggato può visualizzare gli eventi
    can :read, Event

    return unless user.organizer?
    # solo gli organizatori possono gestire gli eventi (ognuno solo i suoi)
    can :manage, Event, user:user

  end
end
