# champleague app

Setting up to Run Champleague
==============================================================================

1) Install gems
~/ $ cd champ_league/
~ champ_league $ bundle install

2) Set secret data
~ champ_league $ cp config/secrets.yml.template config/secrets.yml

3) Setup DB
~ champ_league $ bin/rake db:create
~ champ_league $ bin/rake db:migrate

4) Check if everything works fine
~ champ_league $ rspec spec/

5) Run rails server
~ champ_league $ rails s

6) Add few football teams via UI

7) Enjoy!
==============================================================================

