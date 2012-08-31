# from
# http://brainspec.com/blog/2012/07/09/activerecord-inheritance-contexts/

class User < ActiveRecord::Base
  belongs_to :company

  attr_accessible :email
  validates :role, inclusion: { in: %w(admin company_admin company_member) }

  class Context < User
    class << self
      def model_name
        User.model_name
      end
    end
  end

  class AdminContext < Context
    attr_accessible :role, :company_id
  end

  class CompanyAdminContext < Context
    attr_accessible :role
    validates :role, inclusion: { in: %w(company_admin company_member) }
  end
end


# controller
############################################################
class Admin::UsersController < ApplicationController
  def create
    @user = user_base.new(params[:user])
    @user.company = current_user.company if current_user.company
    @user.save
    respond_with :admin, @user
  end

  private

  def user_base
    if current_user.company?
      User::CompanyAdminContext
    else
      User::AdminContext
    end
  end
end
