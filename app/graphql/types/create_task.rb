module Mutations
  class CreateTask < BaseMutation
    argument :user_id, ID, required: true
    argument :title, String, required: true
    argument :description, String, required: false
    argument :status, String, required: true
    argument :due_date, GraphQL::Types::ISO8601Date, required: true

    type Types::TaskType

    def resolve(**attrs)
      Task.create!(attrs)
    end
  end
end
