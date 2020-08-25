module PermissionHelper
  def check_permissions(options, **)
    url = 'http://localhost:3000/api/v1/permissions'

    resp = Faraday.post(url, { token: options[:token] }.to_json, "Content-Type" => "application/json")
    resp.status == 200
  end
end