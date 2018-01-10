class UserSearchesController < BaseController
  layout 'darkswarm'

  def create
    search = Spree::UserSearch.where(term: params[:term], email: spree_current_user.try(:email), user_ip: request.ip).first
    if search.blank?
      search = Spree::UserSearch.new(term: params[:term], email: spree_current_user.try(:email), user_ip: request.ip)
      if search.save
        render json: {message: "Search term saved successfully"}, status: 201 and return
      else
        render json: {message: search.errors.full_messages}, status: 400 and return
      end
    end
    render json: {message: "Search term is already saved"}, status: 200 and return
  end

  private
end
