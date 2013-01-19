module Leasingx
  class ApplicationController < ActionController::Base
    include Authentify::SessionsHelper
    include Authentify::UserPrivilegeHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
  end
end
