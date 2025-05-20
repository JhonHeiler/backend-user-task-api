module Types
  class QueryType < Types::BaseObject
    field :users, [UserType], null: false
    field :tasks, [TaskType], null: false

    def users; User.all; end
    def tasks; Task.all; end
  end
end
