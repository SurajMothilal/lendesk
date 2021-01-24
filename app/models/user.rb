class User
    include ActiveModel::Validations

    attr_accessor :username, :password

    validates :username, presence: true, format: { with: /\A[a-z0-9_]{4,16}\z/, message: "Username should only contain alphanumeric characters or underscore" }
    validates :password, presence: true
end