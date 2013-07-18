module ApplicationHelper
  def top_destinations_list
    Destination.all.sort {
      |a, b| b.users.size <=> a.users.size
    }
  end

  # def trending_destinations_list
  #   Destination.where
  # end


end
