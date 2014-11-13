module TomtomWebfleetConnect
  module Configuration

    VALID_CONNECTION_KEYS = [:endpoint, :user_agent, :method].freeze
    VALID_ACCOUNT_KEYS    = [:api_key, :account, :user, :mdp].freeze
    VALID_OPTIONS_KEYS    = [:format, :lang, :use_ISO8601, :use_UTF8].freeze
    VALID_CONFIG_KEYS     = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS + VALID_ACCOUNT_KEYS

    DEFAULT_ENDPOINT    = 'https://csv.business.tomtom.com/extern'
    DEFAULT_METHOD      = :get
    DEFAULT_USER_AGENT  = "Tomtom Webfleet connect API Ruby Gem #{TomtomWebfleetConnect::VERSION}".freeze

    DEFAULT_API_KEY     = nil
    DEFAULT_ACCOUNT     = nil
    DEFAULT_USER        = nil
    DEFAULT_MDP         = nil

    DEFAULT_FORMAT        = :json
    DEFAULT_LANG          = 'en'
    DEFAULT_USE_ISO8601   = true
    DEFAULT_USE_UTF8      = true


    # Build accessor methods for every config options so we can do this, for example:
    #   TomtomWebfleetConnect.format = :xml
    attr_accessor *VALID_CONFIG_KEYS

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end

    def reset
      self.endpoint     = DEFAULT_ENDPOINT
      self.method       = DEFAULT_METHOD
      self.user_agent   = DEFAULT_USER_AGENT

      self.api_key      = DEFAULT_API_KEY
      self.account      = DEFAULT_ACCOUNT
      self.user         = DEFAULT_USER
      self.mdp          = DEFAULT_MDP

      self.format       = DEFAULT_FORMAT
      self.lang         = DEFAULT_LANG
      self.use_ISO8601  = DEFAULT_USE_ISO8601
      self.use_UTF8     = DEFAULT_USE_UTF8
    end

    def configure
      yield self
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end

  end
end