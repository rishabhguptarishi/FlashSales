namespace :deals do
  desc "publish & unpublish deals"
  task publish: :environment do
    #FIXME_AB: live false published untouched
    Deal.live_deals.update_all(live: false)

    #FIXME_AB: Deal.publishable.scheduled_to_go_live_today and then mark them live and published
    Deal.publishable.scheduled_to_go_live_today.find_each do |deal|
      deal.update(published: true, live: true)
    end
  end
end
