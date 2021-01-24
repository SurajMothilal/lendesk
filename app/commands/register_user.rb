class RegisterUser
    prepend SimpleCommand

    def initialize(params)
        @user = User.new
        @user.username = params[:username]&.downcase
        @user.password = params[:password]
    end

    def call
        if @user.valid?
            created_user = create_user
            JsonWebToken.encode(user_id: created_user[:username], password: created_user[:password] ) if created_user
        else
            errors.add :user, @user.errors.messages
        end
    end

    private

    attr_accessor :user

    def create_user
        if $redis.exists?(user.username)
            errors.add :username, 'Username already exists'
            return
        end
        encypted_password = BCrypt::Password.create(user.password)
        result = $redis.hmset(user.username, 'password', encypted_password)
        return { username: user.username, password: encypted_password } if result === "OK"

        nil
    end
end