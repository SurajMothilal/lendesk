class AuthorizeUser
    prepend SimpleCommand

    def initialize(headers = {})
        @headers = headers
    end

    def call
        user
    end

    private

    attr_reader :headers

    def user
        @user ||= authenticate_user[:user_id] if authenticate_user
        @user || errors.add(:token, 'Invalid token') && nil
    end

    def authenticate_user
        @user ||= $redis.hgetall(decoded_auth_token[:user_id]) if decoded_auth_token
        return @user if @user && valid_password?(@user, decoded_auth_token[:password])
        nil
    end

    def decoded_auth_token
        @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
    end

    def http_auth_header
        if headers['Authorization'].present?
            return headers['Authorization'].split(' ')&.last
        else
            errors.add(:token, 'Missing token')
        end
        nil
    end

    def valid_password?(user, password)
        BCrypt::Password.new(user["password"]).is_password?(password)
    end
end