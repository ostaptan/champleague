function drawMatchResults(data) {
  for (var i = 0; i < data.length; i++) {
    drawResultsTable(data, i);
  }
};

function drawMatchPredictions(data) {
  var weekRow = $("<tr />");
  var predicts_table = $("#predictions_table");
  predicts_table.append(weekRow);
  weekRow.append($("<td> <b>Week No " + (data.results[0][0].week + 1) + "</b></td>"));
  console.log(data.predicts)

  $.each(data.predicts, function(key, value) {
    var row = $("<tr />");
    predicts_table.append(row);
    row.append($("<td>" + key + "</td>"));
    row.append($("<td>" + value + '%' + "</td>"));
  });

  $(".match_predictions").show();
}

function drawResultsTable(data, index) {
  var weekRow = $("<tr />");
  $("#results_table").append(weekRow);
  weekRow.append($("<td> <b>Week No " + (data[index][0].week + 1) + "</b></td>"));

  for (var i = 0; i < data[index].length; i++) {
    drawRow(data[index][i]);
  }

  $(".match_results").show();
};

function drawRow(rowData) {
  var row = $("<tr />");
  $("#results_table").append(row);
  row.append($("<td>" + rowData.teams[0].name + "</td>"));
  row.append($("<td class=result>" + rowData.result + "</td>"));
  row.append($("<td>" + rowData.teams[1].name + "</td>"));

  $('td.result').editable({
    type: 'text',
    url: '/matches/' + rowData.id,
    pk: 1,
    name: 'result',
    model: 'match',
    title: 'Enter new score:',
    ajaxOptions: {
      type: 'put'
    },
    success: function(response, newValue) {
      console.log(newValue)
      updateTeamsStats();
    },
  });
};

function clearResultsTable() {
  $("#results_table tbody").remove();
};


// <!-- Button trigger modal -->
// <button class="btn btn-link" data-toggle="modal" data-target="#todo-<%= 1 %>-notes">
//   View notes
// </button>
