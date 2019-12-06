json.array! @activities do |activity|
    json.lat activity.latitude
    json.lng activity.longitude
    json.name activity.name
    json.content ActivitiesController.render(partial: 'activities/activity', locals: { activity: activity }, format: :html).squish
  end
