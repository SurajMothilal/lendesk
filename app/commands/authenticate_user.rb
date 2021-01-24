class AuthenticateUser
    prepend SimpleCommand

    def initialize(params)
        @username = params[:username]&.downcase
        @password = params[:password]
    end

    def call
        current_user = login
        JsonWebToken.encode(user_id: current_user[:username], password: current_user[:password] ) if current_user
    end

    private

    attr_accessor :username, :password

    def login
        if $redis.exists?(username)
            @user = $redis.hgetall(username)
            if @user && valid_password?(@user, password)
                return { username: username, password: @user["password"] }
            else
                errors.add(:password, 'Invalid credentials')
                return false
            end
        end

        errors.add(:username, 'Username does not exist')
        nil
    end

    def valid_password?(user, password)
        BCrypt::Password.new(user["password"]).is_password?(password)
    end
end