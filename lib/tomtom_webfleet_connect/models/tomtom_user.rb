module TomtomWebfleetConnect
  module Models
    class TomtomUser

      attr_accessor :username, :realname, :company, :validfrom, :validto, :lastlogin, :profile, :profilename, :userinfo, :passwordexpiration, :useruid


      private

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
      def show_users(options = {})
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
      def change_password(options = {})
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
            action: 'insertUser'
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
            action: 'updateUser'
        }

        unless options.blank?
          defaults = defaults.merge(options)
        end

        defaults
      end

    end
  end
end