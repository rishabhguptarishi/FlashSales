namespace :deals do
  desc "publish & unpublish deals"
  task publish: :environment do
    Deal.live_deals.update_all(live: false, published: true)
    Deal.where(publish_at: Time.current.at_beginning_of_day..Time.current.at_end_of_day).find_each do |deal|
      if deal.can_be_published?
        deal.update(publishable: true, live: true)
      end
    end
  end
end