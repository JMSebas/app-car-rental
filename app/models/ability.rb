# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    return unless user.present?

    if user.role == "administrador"
      can :manage, :all
    end 

    if user.role == "client"
      can [:reservations_user, :create, :destroy, :update], Reservation
      can [:read, :available], Vehicle
    end

    if user.role == "employee"
      can :manage, :all
      cannot :manage, User
    end
   
  end
end
