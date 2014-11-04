module TomtomWebfleetConnect
  module Models
    class TomtomUser

      attr_accessor :username, :realname, :company, :validfrom, :validto, :lastlogin, :profile, :profilename, :userinfo, :passwordexpiration, :useruid,
                    :email, :info,
                    :right

      module PROFILES
        ALL = [
            ['Guest login only', GUEST_LOGIN_ONLY = 'guest_login_only'],
            ['Standard login only', STANDARD_LOGIN_ONLY = 'standard_login_only'],
            ['Guest', GUEST = 'guest'],
            ['Standard', STANDARD = 'standard'],
            ['Expert', EXPERT = 'expert'],
            ['Admin', ADMIN = 'admin']
        ]
      end

      def initialize(api, params = {})
        @api = api

        @username = params[:username].present? ? params[:username][0...50] : ''
        @realname = params[:realname].present? ? params[:realname][0...50] : ''
        @company = params[:company].present? ? params[:company][0...50] : ''
        @validfrom = params[:validfrom].present? ? params[:validfrom] : ''
        @validto = params[:validto].present? ? params[:validto] : ''
        @lastlogin = params[:lastlogin].present? ? params[:lastlogin] : ''
        @profile = params[:profile].present? ? params[:profile][0...50] : ''
        @profilename = params[:profilename].present? ? params[:profilename] : ''
        @userinfo = params[:userinfo].present? ? params[:userinfo][0...4000] : ''
        @passwordexpiration = params[:passwordexpiration].present? ? params[:passwordexpiration] : ''
        @useruid = params[:useruid].present? ? params[:useruid][0...30] : ''

        @email = params[:email].present? ? params[:email][0...255] : ''
        @info = params[:info].present? ? params[:info][0...500] : ''

        @right = TomtomWebfleetConnect::Models::TomtomUser::UserRight.new(params)
      end

      class << self

        def create(api, params = {})
          user = TomtomWebfleetConnect::Models::TomtomUser.new(api, params)

          response = api.send_request(user.insert_user)

          if response.error
            user = nil
            raise CreateUserError, "Error #{response.response_code}: #{response.response_message}"
          end

          user
        end

        # Filter used to match any user name, real name and/or company name in the
        # account containing the indicated string, also as substring.
        def where(api, username_filter, realname_filter, company_filter)
          users = []
          params = {}

          unless username_filter.blank?
            params = params.merge({username_filter: username_filter})
          end

          unless realname_filter.blank?
            params = params.merge({realname_filter: realname_filter})
          end

          unless company_filter.blank?
            params = params.merge({company_filter: company_filter})
          end

          response = api.send_request(TomtomWebfleetConnect::Models::TomtomUser.show_users(params))

          if response.error
            raise ShowUsersError, "Error #{response.response_code}: #{response.response_message}"
          else
            if response.response_body.instance_of?(Hash)
              users << TomtomWebfleetConnect::Models::TomtomUser.new(api, response.response_body)
            elsif response.response_body.instance_of?(Array)
              response.response_body.each do |line_order|
                users << TomtomWebfleetConnect::Models::TomtomUser.new(api, line_order)
              end
            end
          end

          users
        end
      end

      def update(params)
        response = @api.send_request(update_user(params))

        if response.error
          raise UpdateUserError, "Error #{response.response_code}: #{response.response_message}"
        else
          update_params(params)
        end

        self
      end

      def delete
        response = @api.send_request(delete_user)

        if response.error
          raise DeleteUserError, "Error #{response.response_code}: #{response.response_message}"
        end

        self
      end

      # Get User on Webfleet and reset User object
      def refresh
        params = {}

        unless @username.blank?
          params = params.merge({username_filter: @username})
        end

        unless @realname.blank?
          params = params.merge({realname_filter: @realname})
        end

        unless @company.blank?
          params = params.merge({company_filter: @company})
        end

        response = api.send_request(TomtomWebfleetConnect::Models::TomtomUser.show_users(params))

        if response.error
          raise RefreshUserError, "Error #{response.response_code}: #{response.response_message}"
        else
          update_params(response.response_body)
        end

        self
      end

      private

      def update_params(params)
        @username = params[:username].present? ? params[:username][0...50] : ''
        @realname = params[:realname].present? ? params[:realname][0...50] : ''
        @company = params[:company].present? ? params[:company][0...50] : ''
        @validfrom = params[:validfrom].present? ? params[:validfrom] : ''
        @validto = params[:validto].present? ? params[:validto] : ''
        @lastlogin = params[:lastlogin].present? ? params[:lastlogin] : ''
        @profile = params[:profile].present? ? params[:profile][0...50] : ''
        @profilename = params[:profilename].present? ? params[:profilename] : ''
        @userinfo = params[:userinfo].present? ? params[:userinfo][0...4000] : ''
        @passwordexpiration = params[:passwordexpiration].present? ? params[:passwordexpiration] : ''
        @useruid = params[:useruid].present? ? params[:useruid][0...30] : ''

        @email = params[:email].present? ? params[:email][0...255] : ''
        @info = params[:info].present? ? params[:info][0...500] : ''
      end

      def get_hash_for_insert(params)
        object_hash= Hash.new



        object_hash
      end

      # This actions returns a list of all existing users within the account along with the last
      # recorded login time.
      #
      # Request limits 10 requests / minute
      #
      # showUsers requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to showUsers
      # Optional:
      # _______________________________________________________________________________________________________
      #  PARAMETER        |          TYPE               |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  username_filter  | string (max. 50 characters) | Filter used to match any user name in the account
      #                                                   containing the indicated string, also as substring.
      # -------------------------------------------------------------------------------------------------------
      #  realname_filter  | string (max. 50 characters) | Filter used to match any real name of a user in the
      #                                                   account containing the indicated string, also as substring.
      # -------------------------------------------------------------------------------------------------------
      #  company_filter   | string (max. 50 characters) | Filter used to match any company name in the account
      #                                                   containing the indicated string, also as substring.
      # -------------------------------------------------------------------------------------------------------
      #
      def self.show_users(options = {})
        defaults={
            action: 'showUsers'
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

      # Using changePassword you can change the password of your own user account.
      #
      # Request limits 10 requests / hour
      #
      # changePassword requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to changePassword
      # Mandatory:
      # ___________________________________________________________________
      #  PARAMETER    |  TYPE  |  DESCRIPTION
      # -------------------------------------------------------------------
      #  oldpassword  | string | The current password of your user account.
      # -------------------------------------------------------------------
      #  newpassword  | string | The new password.
      # -------------------------------------------------------------------
      #
      def self.change_password(options = {})
        defaults={
            action: 'changePassword'
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

      # Using insertUser you can create a new WEBFLEET user within the current
      # account.
      # Note: This action can only be executed by users, that have the "Administrator"
      # profile.
      #
      # Request limits 10 requests / minute
      #
      # insertUser requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to insertUser
      # Mandatory:
      # _______________________________________________________________________________________________________
      #  PARAMETER        |  TYPE       |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  new_username     | string (50) | User name of the newly created user.
      # -------------------------------------------------------------------------------------------------------
      #      realname     | string (50) | The full name of the user.
      # -------------------------------------------------------------------------------------------------------
      #         email     | string (255)| The e-mail address of the user.
      # -------------------------------------------------------------------------------------------------------
      #       profile     | string (50) |  The profile of the user, see showUsers.
      #                                    Valid values are:
      #                                    - guest_login_only
      #                                    - guest
      #                                    - standard_login_only
      #                                    - standard
      #                                    - expert
      #                                    - admin
      # -------------------------------------------------------------------------------------------------------
      #
      # Optional:
      # _______________________________________________________________________________________________________
      #  PARAMETER               |  TYPE        |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  new_password            | string (255) | The password of the newly created user. You can
      #                                           leave this empty to let WEBFLEET create a new
      #                                           random pasword. The password will be sent to
      #                                           the email address of the newly created user.
      # -------------------------------------------------------------------------------------------------------
      #  require_password_change | boolean      | If this parameter is set to true, The new user is
      #                                           forced to change the password when they log on
      #                                           to WEBFLEET for the first time.
      #                                           This parameter affects the WEBFLEET user inter-
      #                                           face only, but not WEBFLEET.connect.
      #                                           Default is true.
      # -------------------------------------------------------------------------------------------------------
      #  info                    | string (500) | A descriptive text.
      # -------------------------------------------------------------------------------------------------------
      #  company                 | string (50)  | The name of the company.
      # -------------------------------------------------------------------------------------------------------
      #  validfrom               | datetime     | Defines the start date of the validity of the user
      #                                           account. You can omit this parameter if not
      #                                           needed.
      #                                           Default is null.
      # -------------------------------------------------------------------------------------------------------
      #  validto                 | datetime     | Defines the end date of the validity of the user
      #                                           account. You can omit this parameter if not
      #                                           needed.
      #                                           Default is null.
      # -------------------------------------------------------------------------------------------------------
      #
      def insert_user(options = {})
        defaults={
            action: 'insertUser',
            new_username: @username,
            realname: @realname,
            email: @email,
            profile: @profile
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

      # Using updateUser you can update the details of a WEBFLEET user within the
      # current account.
      # Note: This action can only be executed by users, that have the "Administrator"
      # profile.
      #
      # Request limits 10 requests / minute
      #
      # insertUser requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to updateUser
      # Require:
      # _______________________________________________________________________________________________________
      #  PARAMETER       |  TYPE         |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  target_useruid  |  string (30)  | A unique, unchangeable identifier for the user,
      #                                    automatically generated by WEBFLEET. The
      #                                    useruid is returned by showUsers.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username
      # -------------------------------------------------------------------------------------------------------
      #  target_username |  string (50)  | User name of the user.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username.
      # -------------------------------------------------------------------------------------------------------
      #
      # Optional:
      # _______________________________________________________________________________________________________
      #  PARAMETER               |  TYPE           |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  new_username            |  string (50)    | User name of the newly created user.
      #                                              It is required only if the user name shall be
      #                                              changed.
      # -------------------------------------------------------------------------------------------------------
      #  new_password            |  string (255)  |  Defines a new password for the user.
      #                                              You can omit this parameter to not change the
      #                                              password.
      # -------------------------------------------------------------------------------------------------------
      #  generate_password       |  boolean       |  Generates a password for the user.
      #                                              If set to true a new random pasword will be gen-
      #                                              erated by WEBFLEET. The password will be sent
      #                                              to the email address of the user.
      #                                              Omit this parameter to not change the password.
      # -------------------------------------------------------------------------------------------------------
      #  require_password_change |  boolean       | If this parameter is set to true, the user is forced
      #                                             to change the password when they log on to
      #                                             WEBFLEET for the first time.
      #                                             This parameter affects the WEBFLEET user inter-
      #                                             face only, but not WEBFLEET.connect.
      # -------------------------------------------------------------------------------------------------------
      #  realname                |  string (50)    |  The full name of the user.
      # -------------------------------------------------------------------------------------------------------
      #  info                    |  string (500)   |  A descriptive text.
      # -------------------------------------------------------------------------------------------------------
      #  company                 |  string (50)    |  The name of the company.
      # -------------------------------------------------------------------------------------------------------
      #  email                   |  string (255)   |  The e-mail address of the user.
      # -------------------------------------------------------------------------------------------------------
      #  validfrom               |  datetime       |  Defines the start date of the validity of the user
      #                                               account. You can omit this parameter if not
      #                                               needed.
      #                                               Default is null.
      # -------------------------------------------------------------------------------------------------------
      #  validto                 |  datetime       |  Defines the end date of the validity of the user
      #                                               account. You can omit this parameter if not
      #                                               needed.
      #                                               Default is null.
      # -------------------------------------------------------------------------------------------------------
      #  profile                 |  string (50)    |  The profile of the user, see showUsers.
      #                                               Valid values are:
      #                                               - guest_login_only
      #                                               - guest
      #                                               - standard_login_only
      #                                               - standard
      #                                               - expert
      #                                               - admin
      # -------------------------------------------------------------------------------------------------------
      #
      def update_user(options = {})
        defaults={
            action: 'updateUser',
            target_username: @username
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

      # Using deleteUser you can delete a WEBFLEET user within the current account.
      # Note: This action can only be executed by users, that have the "Administrator"
      # profile.
      #
      # Request limits 10 requests / minute
      #
      # deleteUser requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to updateUser
      # Require:
      # _______________________________________________________________________________________________________
      #  PARAMETER       |  TYPE         |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  target_useruid  |  string (30)  | A unique, unchangeable identifier for the user,
      #                                    automatically generated by WEBFLEET. The
      #                                    useruid is returned by showUsers.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username
      # -------------------------------------------------------------------------------------------------------
      #  target_username |  string (50)  | User name of the user.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username.
      # -------------------------------------------------------------------------------------------------------
      #
      def delete_user(options = {})
        {
            action: 'deleteUser',
            target_username: @username
        }
      end

      # This action returns the currently configured access right levels for a specified user.
      # The result contains profile default rights and individually configured rights.
      # Note: This action can only be executed by users, that have the "Administrator"
      # profile.
      #
      # Request limits 10 requests / minute
      #
      # getUserRights requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to updateUser
      # Require:
      # _______________________________________________________________________________________________________
      #  PARAMETER       |  TYPE         |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  target_useruid  |  string (30)  | A unique, unchangeable identifier for the user,
      #                                    automatically generated by WEBFLEET. The
      #                                    useruid is returned by showUsers.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username
      # -------------------------------------------------------------------------------------------------------
      #  target_username |  string (50)  | User name of the user.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username.
      # -------------------------------------------------------------------------------------------------------
      #
      def get_user_rights(options = {})
        {
            action: 'getUserRights',
            target_username: @username
        }
      end

      # This action adds a right level to an individual user.
      # Note: This action can only be executed by users, that have the "Administrator"
      # profile.
      #
      # Request limits 10 requests / minute
      #
      # setUserRight requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to updateUser
      # Require:
      # _______________________________________________________________________________________________________
      #  PARAMETER       |  TYPE         |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  target_useruid  |  string (30)  | A unique, unchangeable identifier for the user,
      #                                    automatically generated by WEBFLEET. The
      #                                    useruid is returned by showUsers.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username
      # -------------------------------------------------------------------------------------------------------
      #  target_username |  string (50)  | User name of the user.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username.
      # -------------------------------------------------------------------------------------------------------
      #   rightlevel     |    string     | The name of the right level, see List of supported
      #                                    right levels.
      # -------------------------------------------------------------------------------------------------------
      #   entityuid     |    string     | The UID of the entity the right applies to.
      #
      #                                   Note: You can only assign right levels to entities
      #                                   when they are supported by the entitytype of
      #                                   the indicated entityuid. For example, you can-
      #                                   not assign the right level object_full_access
      #                                   to an entity of the entity type driver.
      #
      #                                   Omit this parameter for global rights.
      # -------------------------------------------------------------------------------------------------------
      #
      def set_user_right(rightlevel, options = {})
        defaults={
            action: 'setUserRight',
            target_username: @username,
            rightlevel: rightlevel
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

      # Using resetUserRights you can reset the user access right levels to the profile
      # defaults. All individual configured rights will be lost after executing this function.
      # Note: This action can only be executed by users, that have the "Administrator"
      # profile.
      #
      # Request limits 10 requests / minute
      #
      # resetUserRights requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to updateUser
      # Require:
      # _______________________________________________________________________________________________________
      #  PARAMETER       |  TYPE         |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  target_useruid  |  string (30)  | A unique, unchangeable identifier for the user,
      #                                    automatically generated by WEBFLEET. The
      #                                    useruid is returned by showUsers.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username
      # -------------------------------------------------------------------------------------------------------
      #  target_username |  string (50)  | User name of the user.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username.
      # -------------------------------------------------------------------------------------------------------
      #
      def reset_user_rights(options = {})
        defaults={
            action: 'resetUserRights',
            target_username: @username
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

      # This action removes a right level from an individual user.
      # Note: This action can only be executed by users, that have the "Administrator"
      # profile
      #
      # Request limits 10 requests / minute
      #
      # removeUserRight requires the following common parameters:
      # - Authentication parameters
      # - General parameters
      #
      # Parameters specific to updateUser
      # Require:
      # _______________________________________________________________________________________________________
      #  PARAMETER       |  TYPE         |  DESCRIPTION
      # -------------------------------------------------------------------------------------------------------
      #  target_useruid  |  string (30)  | A unique, unchangeable identifier for the user,
      #                                    automatically generated by WEBFLEET. The
      #                                    useruid is returned by showUsers.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username
      # -------------------------------------------------------------------------------------------------------
      #  target_username |  string (50)  | User name of the user.
      #                                    It is mandatory to indicate target_useruid
      #                                    and/or target_username.
      # -------------------------------------------------------------------------------------------------------
      #   rightlevel     |    string     | The name of the right level, see List of supported
      #                                    right levels.
      # -------------------------------------------------------------------------------------------------------
      #   entityuid     |    string     | The UID of the entity the right applies to.
      #
      #                                   Note: You can only assign right levels to entities
      #                                   when they are supported by the entitytype of
      #                                   the indicated entityuid. For example, you can-
      #                                   not assign the right level object_full_access
      #                                   to an entity of the entity type driver.
      #
      #                                   Omit this parameter for global rights.
      # -------------------------------------------------------------------------------------------------------
      #
      def remove_user_right(rightlevel, options = {})
        defaults={
            action: 'removeUserRight',
            target_username: @username,
            rightlevel: rightlevel
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

    end
  end

  class CreateUserError < StandardError
  end
  class UpdateUserError < StandardError
  end
  class ShowUsersError < StandardError
  end
  class DeleteUserError < StandardError
  end
  class RefreshUserError < StandardError
  end

  class UserRight

    attr_accessor :rightlevel, :entityuid, :entitytype

    module RIGHT_LEVELS
      ALL = [
          ['Allowed to access WEBFLEET.connect API', EXTERNAL_ACCESS = 'external_access'],
          ['Allowed to change account settings.', FULL_ACCESS_ACCOUNTSETTINGS = 'full_access_accountsettings'],
          ['User can change own settings.', EDIT_USERSETTINGS = 'edit_usersettings'],
          ['User can change his own password.', CHANGE_PASSWORD = 'change_password'],
          ['Access to trip related data.', TRIP_DATA_ACCESS = 'trip_data_access'],
          ['Read/Write access to areas.', AREAS_FULL_ACCESS = 'areas_full_access'],
          ['Read access to areas.', AREAS_READ_ACCESS = 'areas_read_access'],
          ['Full access to order management functions.', ORDERS_FULL_ACCESS = 'orders_full_access'],
          ['Read access to orders.', ORDERS_READ_ACCESS = 'orders_read_access'],
          ['Access to the tachograph page', EXTERNAL_TACHOGRAPH_INTERFACE = 'external_tachograph_interface'],
          ['Full read/write access to vehicles, messaging, tracking, change group association etc.', OBJECT_FULL_ACCESS = 'object_full_access'],
          ['Full read/write access to vehicles, messaging, tracking', OBJECT_EXPERT_ACCESS = 'object_expert_access'],
          ['Read access to vehicles, messaging, tracking', OBJECT_STANDARD_ACCESS = 'object_standard_access'],
          ['Read access to vehicles, tracking, read messages', OBJECT_TRACKING = 'object_tracking'],
          ['Read access to vehicles, view position', OBJECT_LOCATING = 'object_locating'],
          ['Read access to vehicles, view position, messaging', OBJECT_LOCATING_AND_MESSAGING = 'object_locating_and_messaging'],
          ['Read access to vehicles, view position, messaging', OBJECT_LOCATING_AND_COMMUNICATION = 'object_locating_and_communication'],
          ['Read access to vehicles, messaging, no position info', OBJECT_MESSAGING = 'object_messaging'],
          ['Read access to vehicles, view position', OBJECT_READ_ACCESS = 'object_read_access'],
          ['Full edit access to addresses including address group assignments', ADDRESS_ADMIN_ACCESS = 'address_admin_access'],
          ['Edit access to addresses', ADDRESS_EDIT_ACCESS = 'address_edit_access'],
          ['Read access to addresses', ADDRESS_READ_ACCESS = 'address_read_access'],
          ['Full edit access to drivers, including driver group assignments', DRIVER_ADMIN_ACCESS = 'driver_admin_access'],
          ['Edit access to drivers', DRIVER_EDIT_ACCESS = 'driver_edit_access'],
          ['Read access to drivers', DRIVER_READ_ACCESS = 'driver_read_access']
      ]
    end

    module ENTITY_TYPE
      ALL = [
          ['object', OBJECT = 'object'],
          ['objectgroup', OBJECT_GROUP = 'objectgroup'],
          ['driver', DRIVER = 'driver'],
          ['drivergroup', DRIVER_GROUP = 'drivergroup'],
          ['address', ADDRESS = 'address'],
          ['addressgroup', ADDRESS_GROUP = 'addressgroup']
      ]
    end

    public

    def initialize(params = {})
      @rightlevel = params[:rightlevel] if params[:rightlevel].present?
      @entityuid = params[:entityuid] if params[:entityuid].present?
      @entitytype = params[:entitytype] if params[:entitytype].present?
    end

    def update(params)
      @rightlevel = params[:rightlevel].present? ? params[:rightlevel] : nil
      @entityuid = params[:entityuid].present? ? params[:entityuid] : nil
      @entitytype = params[:entitytype].present? ? params[:entitytype] : nil
    end

    def to_hash
      object_hash= Hash.new

      object_hash = object_hash.merge({rightlevel: @rightlevel}) unless @rightlevel.blank?
      object_hash = object_hash.merge({entityuid: @entityuid}) unless @entityuid.blank?
      object_hash = object_hash.merge({entitytype: @entitytype}) unless @entitytype.blank?

      object_hash
    end

  end

end