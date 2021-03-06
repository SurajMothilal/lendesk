class User
    include ActiveModel::Validations

    attr_accessor :username, :password

    validates :username, presence: true, format: { with: /\A[a-z0-9_]{4,16}\z/, message: "Username should only contain alphanumeric characters or underscore" }
    validates :password, presence: true, format: { with: /\A^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$\z/, message: "Password must be atleast 8 characters long and contain at least one letter, one special character and one number" }
end