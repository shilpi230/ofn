class SubscriptionsController < ApplicationController

  def unsubscribe
    fms = FarmersMarketSubscriber.where(email: params[:email])
    if fms.present?
      fms.update_all(unsubscribed: true)
      flash[:success] = 'You have unsubscribed successfully.'
      redirect_to root_path
    else
      flash[:error] = 'Unable to unsubscribe please try again after some time.'
      redirect_to root_path
    end
  end
end
