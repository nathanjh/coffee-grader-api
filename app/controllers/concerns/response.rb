# pass in object to serialize, and any options (as options hash), eg. explicit
# serializer, http status code
module Response
  def json_response(object, options = { status: :ok })
    if options[:serializer]
      render json: object,
             serializer: options[:serializer],
             status: options[:status]
    else
      render json: object, status: options[:status]
    end
  end
end
