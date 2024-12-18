document.getElementById('fileInput').addEventListener('change', handleFile);

function handleFile(event) {
  const file = event.target.files[0];
  if (file) {
    Papa.parse(file, {
      header: true, // Read headers automatically
      skipEmptyLines: true,
      complete: function (results) {
        const data = results.data;
        createCharts(data);
      }
    });
  }
}

function createCharts(data) {
  const dates = data.map(row => row.Date);
  const sales = data.map(row => parseFloat(row.Sales));
  const profit = data.map(row => parseFloat(row.Profit));

  // Chart 1: Sales Over Time
  new Chart(document.getElementById('chart1'), {
    type: 'line',
    data: {
      labels: dates,
      datasets: [
        {
          label: 'Sales',
          data: sales,
          borderColor: 'blue',
          fill: false,
        }
      ]
    }
  });

  // Chart 2: Profit Over Time
  new Chart(document.getElementById('chart2'), {
    type: 'bar',
    data: {
      labels: dates,
      datasets: [
        {
          label: 'Profit',
          data: profit,
          backgroundColor: 'green',
        }
      ]
    }
  });
}
