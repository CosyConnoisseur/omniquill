class CampaignPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def show?
    user == record.user || record.participations.exists?
  end

  def create?
    true
  end

  def destroy?
    user == record.user
  end

  def edit?
    user == record.user
  end

  def update?
    user == record.user
  end

  def invite?
    user == record.user
  end

  def add_player?
    user == record.user
  end

  def join?
    true
  end

  # def show?
  #   true
  # end

  def record?
    show?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.left_joins(:participations)
           .where(user_id: user.id)
           .or(scope.left_joins(:participations).where(participations: { user_id: user.id }))
           .distinct
      # participations user?
    end
  end
end
