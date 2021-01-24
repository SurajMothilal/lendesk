require 'securerandom'

class JsonWebToken
    SECRET = SecureRandom.random_bytes(20)
    class << self
        def encode(payload, exp = 1.hours.from_now)
            payload[:exp] = exp.to_i
            JWT.encode(payload, SECRET)
        end

        def decode(token)
            body = JWT.decode(token, SECRET)[0]
            HashWithIndifferentAccess.new body
        rescue
            nil
        end
    end
end