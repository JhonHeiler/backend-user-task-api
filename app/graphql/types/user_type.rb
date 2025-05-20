module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :full_name, String, null: false
    field :role, String, null: false
    field :tasks, [TaskType], null: true
  end

  class TaskType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :status, String
    field :due_date, GraphQL::Types::ISO8601Date
    field :user, UserType, null: false
  end
end
