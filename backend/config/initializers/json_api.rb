ActiveModel::Serializer.config.adapter = :json_api

Mime::Type.register "application/json", :json, %w( text/x-json application/jsonrequest application/vnd.api+json )
