module Admin::RedeemRequestsHelper

  def total_capital_of_points
    RedeemRequest.where(status: false).sum(:points)/10
  end
  
end
