class ChapterPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def show?
    # This is a failsafe in case a user decides to manipulate the url itself to access campaigns/chapters they aren't supposed to.
    # Kept the code below for future reference, but don't need it anymore.
    # user.participations.where(campaign_id: record.campaign.id).present? || user.campaigns.exists?(id: record.campaign.id)
    true
  end

  def edit?
    update?
  end

  def update?
    true
  end
end
