Geocoder.configure(
  # Geocoding options
  # timeout: 3,                 # geocoding service timeout (secs)
  lookup: :google, # name of geocoding service (symbol)
  ip_lookup: :ipstack, # name of IP address geocoding service (symbol)
  # language: :en,              # ISO-639 language code
  # use_https: false,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  google: {
    api_key: Rails.env.test? ? 'GOOGLE_API_KEY' : ENV['GOOGLE_API_KEY'] # Lat/Long -> region & post code
  },
  ipstack: {
    api_key: Rails.env.test? ? 'IPSTACK_API_KEY' : ENV['IPSTACK_API_KEY'] # IP -> region & post code
  }
  # cache: nil,                 # cache object (must respond to #[], #[]=, and #del)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys

  # Exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and Timeout::Error
  # always_raise: [],

  # Calculation options
  # units: :mi,                 # :km for kilometers or :mi for miles
  # distances: :linear          # :spherical or :linear
)
