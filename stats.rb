require 'trello'

include Trello
include Trello::Authorization

Trello::Authorization.const_set :AuthPolicy, OAuthPolicy

OAuthPolicy.consumer_credential = OAuthCredential.new ENV['TRELLO_API_KEY'], ENV['TRELLO_API_SECRET']
OAuthPolicy.token = OAuthCredential.new ENV['TRELLO_API_TOKEN'], nil

count_by_state = {}
count_by_label = {}
checklist_totals = [0,0]

board = Trello::Board.find(ENV['TRELLO_BOARD_ID'])
board.lists.each do |list|
  next if list.name == 'Ideas'

  count_by_state[list.name] = 0

  list.cards.each do |card|

    count_by_state[list.name] += 1
    labeled = false
    card.labels.each do |label|
      count_by_label[label.name] ||= 0
      count_by_label[label.name] += 1
      labeled = true
    end

    count_by_label["Unlabeled"] ||= 0
    if not labeled
      count_by_label["Unlabeled"] += 1
    end
    

    states = Hash[card.check_item_states.map {|state| [state.item_id, state.state]}]

    card.checklists.each do |checklist|
      checklist.items.each do |item|
        checklist_totals[0] += 1 if states[item.id] == 'complete'
        checklist_totals[1] += 1
      end
    end
  end
end


total = 0
count_by_state.each do |state,count|
  puts "#{state} #{count}"
  total += count
end
puts "Total #{total}"
puts

total = 0
count_by_label.each do |label,count|
  puts "#{label} #{count}"
  total += count
end
puts

puts "Checklist items #{checklist_totals[0]} / #{checklist_totals[1]} (#{checklist_totals[0] * 100 / checklist_totals[1]}%)"
