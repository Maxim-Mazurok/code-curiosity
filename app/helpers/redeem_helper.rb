module RedeemHelper
  def redeem_request_value(user, one_dollar_to_points)
    (Offer.is_winner?(current_user) || (user.is_sponsorer and user.active_sponsorer_detail)) ? one_dollar_to_points : one_dollar_to_points * 2
  end
end
