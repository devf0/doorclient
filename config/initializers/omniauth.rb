# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class DoorAuth < OmniAuth::Strategies::OAuth2
      option :name, 'doorauth'

      option :client_options,
             site: 'http://localhost:7001',
             authorize_url: '/oauth/authorize',
             token_url: '/oauth/token'

      uid { raw_info['id'] }

      info do
        {
          id: raw_info['id'],
          email: raw_info['email']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/me').parsed
      end

      def callback_url
        full_host + script_name + callback_path
      end

      # https://github.com/omniauth/omniauth-oauth2/blob/master/lib/omniauth/strategies/oauth2.rb#L62
      def authorize_params # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        state = { _random: SecureRandom.hex(24) }
        state = state.merge(request.params['state']) if request.params['state']

        options.authorize_params[:state] = Rails.application.message_verifier(:oauth_state).generate(state)

        if OmniAuth.config.test_mode
          @env ||= {}
          @env["rack.session"] ||= {}
        end

        params = options.authorize_params
                        .merge(options_for("authorize"))
                        .merge(pkce_authorize_params)

        session["omniauth.pkce.verifier"] = options.pkce_verifier if options.pkce
        session["omniauth.state"] = params[:state]

        params
      end
    end
  end
end

OmniAuth.config.add_camelization('doorauth', 'DoorAuth')

Rails.application.config.middleware.use OmniAuth::Builder do
  # https://github.com/omniauth/omniauth-oauth2/issues/58#issuecomment-496479936
  provider :doorauth, 'TnEZ8-7jW2Peg0lZaXTrv3pW0aZl4MD4LEiujhYFpZ8', 'T03yv1wHTTEh8_dFngqA7bkHqteqr1WOILC0rozLypY', provider_ignores_state: Rails.env.development?
  # provider :doorauth, 'TnEZ8-7jW2Peg0lZaXTrv3pW0aZl4MD4LEiujhYFpZ8', 'T03yv1wHTTEh8_dFngqA7bkHqteqr1WOILC0rozLypY'
end
