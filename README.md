Uses the Trello API to produce simple statistics:

* How many cards are in each list
* How many cards with each label
* Number and proportion of checklist items that are complete

### Usage

```
$ cp .env.sample .env
$ vi .env
$ foreman run ruby stats.rb [board id] # defaults to $TRELLO_BOARD_ID
```
