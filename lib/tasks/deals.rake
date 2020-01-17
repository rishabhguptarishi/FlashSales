namespace :deals do
  desc "publish & unpublish deals"
  task publish: :environment do
    Deal.transaction do
      Deal.live_deals.update_all(live: false)

      Deal.publishable.scheduled_to_go_live_today.find_each do |deal|
        deal.update!(published: true, live: true)
      end
    end
  end
end
