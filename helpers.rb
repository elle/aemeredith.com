module ApplicationHelpers
  def admin?
    session[:admin] == true
  end

  def announcement
    Announcement.current
  end

  def bread_day_heading
    BreadDay.for_week_of(Date.current).heading
  end

  def correct_password?(password)
    expected = ENV["ADMIN_PASSWORD"].to_s

    !expected.empty? && Rack::Utils.secure_compare(expected, password.to_s)
  end

  def csrf_token
    Rack::Protection::AuthenticityToken.token(session)
  end

  def honeypot_filled?
    !params[:website].to_s.strip.empty?
  end

  def money(amount)
    format("$%.2f", amount)
  end

  def order_error(order, items)
    if items.empty?
      "Please choose at least one loaf."
    else
      order.errors.full_messages.to_sentence
    end
  end

  def ordered_items(breads, quantities)
    quantities ||= {}

    breads.filter_map do |bread|
      quantity = quantities[bread["id"]].to_i

      if quantity.positive?
        {
          id: bread["id"],
          name: bread["name"],
          price: bread["price"],
          quantity: quantity,
        }
      end
    end
  end

  def require_admin!
    unless admin?
      redirect "/bread/admin/login"
    end
  end

  def weekly_breads
    ids = WeeklySelection.current_bread_ids.presence || WEEKLY_BREAD_IDS

    BREADS.select { |bread| ids.include?(bread["id"]) }
  end
end
