

var play_all_matches = function(element) {
  $.post("/matches/play_all.json", function(data) {
    clearResultsTable();
    updateTeamsStats();
    if (data == null) {
      alert('Champion League is finished!');
      leagueFuinished();
    } else {
      drawMatchResults(data);
    }
  });
};

var play_match = function(element) {
  $.post("/matches/play.json", function(data) {
    updateTeamsStats();
    if (data.results[0] == null) {
      alert('Champion League is finished!');
      leagueFuinished();
    } else {
      drawMatchResults(data.results);
      drawMatchPredictions(data);
    }
  });
};

function leagueFuinished() {
  $('.play_all').hide();
  $('.play_match').hide();
  $('.reset_stats').show();
};

function updateTeamsStats() {
  $.get("/teams.json", function(data) {
    $.each(data, function(index, team) {
      $('#points_' + team.id).text(team.points);
      $('#played_' + team.id).text(team.won + team.lost + team.draw);
      $('#won_' + team.id).text(team.won);
      $('#lost_' + team.id).text(team.lost);
      $('#draw_' + team.id).text(team.draw);
      $('#goal_diff_' + team.id).text(team.goal_diff);
    });

  });
};


