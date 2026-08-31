class CharacterPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  def show?
    true
    # add campaign ownership later
  end

  def show_campaign_link?
    create?
    # user == record.participation&.campaign&.user
  end

  def create?
    campaign_record = record.campaign
    return false unless campaign_record

    user == campaign_record.user || campaign_record.participations.exists?(user: user)
    # add campaign ownership
  end

  def new?
    # true
    create?
    # user == record.participation&.campaign.user
  end

  def destroy?
    record.user == user
  end

  def update?
    true
    # user == record.participation.user
    # user == record.participation.user #figure out character ownership
  end

  def parse_sheet?
    true
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      #   scope.all

      scope.where(user: user)

      # for later when we want to be stricter about showing characters
      # Characters -> Participation -> Campaign -> Filter by GM
      # scope.joins(participation: :campaign)
      #      .where(campaigns: { user_id: user.id })

      # Characters -> Participation -> Filter by Player
      # scope.joins(participation)
      #      .where(participations: { user_id: user.id })
    end
  end
end
