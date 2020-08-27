class JwtMock
  class << self
    def payload
      {
        user: 'user@gmail.com',
        create: true
      }
    end

    def token
      JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
    end

    def decode_token(token)
      JWT.decode(token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' })
    end

    def header
      "Bearer #{token}"
    end

    def decode_header(header)
      token_type, token_value = header.to_s.split(' ')
      decode_token(token_value)
    end
  end
end